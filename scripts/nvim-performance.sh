#!/bin/bash

# Neovim Performance Management Script for macOS
# Usage: ./nvim-performance.sh [command]

set -e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

print_usage() {
    echo "Neovim Performance Management Script"
    echo ""
    echo "Usage: $0 [command]"
    echo ""
    echo "Commands:"
    echo "  profile         Profile Neovim startup time"
    echo "  lsp-check       Check running LSP processes"
    echo "  lsp-kill        Kill high CPU LSP processes"
    echo "  memory-usage    Check Neovim memory usage"
    echo "  update-nvim     Update to native macOS build"
    echo "  lazy-profile    Profile Lazy.nvim plugin loading"
    echo "  help            Show this help message"
}

profile_startup() {
    echo -e "${GREEN}🚀 Profiling Neovim startup time...${NC}"
    nvim --startuptime /tmp/nvim-startup.log +q
    echo -e "${YELLOW}Top 10 slowest startup items:${NC}"
    sort -k2 -nr /tmp/nvim-startup.log | head -10
    echo ""
    echo -e "${GREEN}Full startup log saved to: /tmp/nvim-startup.log${NC}"
}

check_lsp_processes() {
    echo -e "${GREEN}🔍 Checking LSP processes...${NC}"
    echo ""
    
    # Check for language servers
    LSP_PROCESSES=$(ps aux | grep -i "language-server\|tsserver\|dartls\|cssls" | grep -v grep || true)
    
    if [ -n "$LSP_PROCESSES" ]; then
        echo -e "${YELLOW}Running LSP processes:${NC}"
        echo "$LSP_PROCESSES"
        echo ""
        
        # Show CPU usage
        echo -e "${YELLOW}CPU usage breakdown:${NC}"
        ps aux | grep -i "language-server\|tsserver\|dartls\|cssls" | grep -v grep | awk '{print $3"% CPU - "$11}' || true
    else
        echo -e "${GREEN}✅ No LSP processes currently running${NC}"
    fi
}

kill_high_cpu_lsp() {
    echo -e "${GREEN}🔪 Checking for high CPU LSP processes...${NC}"
    
    # Find processes using more than 20% CPU
    HIGH_CPU_PIDS=$(ps aux | grep -i "language-server\|tsserver\|dartls\|cssls" | grep -v grep | awk '$3 > 20 {print $2}' || true)
    
    if [ -n "$HIGH_CPU_PIDS" ]; then
        echo -e "${YELLOW}Found high CPU LSP processes. Killing...${NC}"
        for pid in $HIGH_CPU_PIDS; do
            echo "Killing process $pid"
            kill -9 "$pid" 2>/dev/null || true
        done
        echo -e "${GREEN}✅ High CPU LSP processes killed${NC}"
    else
        echo -e "${GREEN}✅ No high CPU LSP processes found${NC}"
    fi
}

check_memory_usage() {
    echo -e "${GREEN}💾 Checking Neovim memory usage...${NC}"
    echo ""
    
    NVIM_PROCESSES=$(ps aux | grep nvim | grep -v grep || true)
    
    if [ -n "$NVIM_PROCESSES" ]; then
        echo -e "${YELLOW}Neovim memory usage:${NC}"
        echo "$NVIM_PROCESSES" | awk '{print $4"% MEM - "$6" KB - "$11}'
        echo ""
        
        # Total memory usage
        TOTAL_MEM=$(echo "$NVIM_PROCESSES" | awk '{sum += $6} END {print sum}')
        echo -e "${YELLOW}Total Neovim memory usage: ${TOTAL_MEM} KB${NC}"
    else
        echo -e "${GREEN}✅ No Neovim processes currently running${NC}"
    fi
}

update_neovim() {
    echo -e "${GREEN}⬆️  Updating to native macOS Neovim build...${NC}"
    
    # Check if Homebrew is installed
    if ! command -v brew &> /dev/null; then
        echo -e "${RED}❌ Homebrew not found. Please install Homebrew first.${NC}"
        exit 1
    fi
    
    # Update Neovim
    echo "Updating Neovim with Homebrew..."
    brew update
    brew upgrade neovim || brew install neovim --HEAD
    
    echo -e "${GREEN}✅ Neovim updated successfully${NC}"
    nvim --version
}

profile_lazy() {
    echo -e "${GREEN}🔌 Profiling Lazy.nvim plugin loading...${NC}"
    
    # Create a temporary profiling script
    cat > /tmp/lazy-profile.lua << 'EOF'
require("lazy").profile()
vim.defer_fn(function()
    vim.cmd('qa!')
end, 1000)
EOF
    
    nvim --headless -u /tmp/lazy-profile.lua
    rm /tmp/lazy-profile.lua
    
    echo -e "${GREEN}✅ Lazy.nvim profiling completed${NC}"
}

# Main script logic
case "${1:-help}" in
    "profile")
        profile_startup
        ;;
    "lsp-check")
        check_lsp_processes
        ;;
    "lsp-kill")
        kill_high_cpu_lsp
        ;;
    "memory-usage")
        check_memory_usage
        ;;
    "update-nvim")
        update_neovim
        ;;
    "lazy-profile")
        profile_lazy
        ;;
    "help"|*)
        print_usage
        ;;
esac

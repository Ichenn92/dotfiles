#! /bin/bash
 
# exclude the logs folder, watch for changes in project mysite.com and refresh active chrome tab
fswatch -o -e 'log' -v  ~/Sites/tree-visualizer/app/ | xargs -n1 -I{} osascript ~/dotfiles/scripts/autorefresh/reloadActiveChromeTab.scptd

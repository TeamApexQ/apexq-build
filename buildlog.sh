MYPATH=$(dirname $0)
export CHANGESPATH=$WORKSPACE/CHANGES.txt
rm $CHANGESPATH 2>/dev/null

prevts=
for ts in `ls -lt --time-style=+%s /var/lib/jenkins/jobs/apexq-staging-4.4/builds/ | grep drwx | tail -n+1 | cut -c36-45`; do

export ts
(echo "===================================" | tee >> $CHANGESPATH
echo -n "Since ";date -u -d @$ts 
echo "===================================" | tee >> $CHANGESPATH
if [ -z "$prevts" ]; then
  repo forall -c 'L=$(git log --oneline --since $ts -n 1); if [ "n$L" != "n" ]; then echo; echo "   * $REPO_PATH"; git log --oneline --since $ts; fi' | tee >> $CHANGESPATH
else
  repo forall -c 'L=$(git log --oneline --since $ts --until $prevts -n 1); if [ "n$L" != "n" ]; then echo; echo "   * $REPO_PATH"; git log --oneline --since $ts --until $prevts; fi' | tee >> $CHANGESPATH
fi
echo)
export prevts=$ts

done

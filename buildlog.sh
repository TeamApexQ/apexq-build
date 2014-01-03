MYPATH=$(dirname $0)
export CHANGESPATH=$WORKSPACE/CHANGES.txt
rm $CHANGESPATH 2>/dev/null

prevts=
for ts in `ls -l /var/lib/jenkins/jobs/apexq-staging-4.4/builds/ | grep drwx | cut -c48-`; do

export ts
(echo "===================================" | tee >> $CHANGESPATH
echo "Since $ts" | tee >> $CHANGESPATH
echo "===================================" | tee >> $CHANGESPATH
if [ -z "$prevts" ]; then
  repo forall -c 'L=$(git log --oneline --since $ts -n 1); if [ "n$L" != "n" ]; then echo; echo "   * $REPO_PATH"; git log --oneline --since $ts; fi' | tee >> $CHANGESPATH
else
  repo forall -c 'L=$(git log --oneline --since $ts --until $prevts -n 1); if [ "n$L" != "n" ]; then echo; echo "   * $REPO_PATH"; git log --oneline --since $ts --until $prevts; fi' | tee >> $CHANGESPATH
fi
echo)
export prevts=$ts

done

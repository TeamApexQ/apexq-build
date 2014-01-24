MYPATH=$(dirname $0)
export CHANGESPATH=$WORKSPACE/CHANGES.txt
rm $CHANGESPATH 2>/dev/null

i=1
prevts=
for ts in `ls -lt --time-style=+%s /var/lib/jenkins/jobs/apexq-staging/builds/ | grep drwx | cut -c35-45`; do

export ts
(echo "==================================="
if [ $i = 1 ]; then
  echo "Locally applied changes"
else
  echo -n "Since $ts : ";date -u -d @$ts 
fi
echo "==================================="
if [ -z "$prevts" ]; then
  repo forall -c 'L=$(git log --oneline --since $ts -n 1); if [ "n$L" != "n" ]; then echo; echo "   * $REPO_PATH"; git log --oneline --since $ts; fi'
else
  repo forall -c 'L=$(git log --oneline --since $ts --until $prevts -n 1); if [ "n$L" != "n" ]; then echo; echo "   * $REPO_PATH"; git log --oneline --since $ts --until $prevts; fi'
fi
echo) >> $CHANGESPATH
export prevts=$ts
i=$((i+1))

done

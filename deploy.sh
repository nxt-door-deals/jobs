set -xe

if [ $TRAVIS_BRANCH == 'main' ] ; then
  eval "$(ssh-agent -s)"
  ssh-add ~/.ssh/id_rsa

  rsync -a --exclude={"db_backup.sh","deploy.sh","travis_rsa.enc","isort.cfg"} * travis@157.245.101.118:/home/ndduser/jobs
  echo "Deployed successfully!"
else
  echo "Not deploying, since the branch isn't main."
fi
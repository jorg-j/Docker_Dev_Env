wget https://github.com/jorg-j/Docker_Dev_Env/archive/main.zip
unzip main.zip

directory="Docker_Dev_Env-main"

while [ ! -d "$directory" ]; do
  echo "Waiting for directory to exist..."
  sleep 1 
done

rm main.zip
mv $directory/* .
rm -r $directory
rm -r .git
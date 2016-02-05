../bin/monkeyc -r -d fr630 -o ./bin/ultitrack-fr630.prg -m ./manifest.xml -z \
./resources/strings.xml:./resources-fr630/strings.xml:./resources/bitmaps.xml:./resources/resources.xml \
./source/UltiTrackApp.mc ./source/UltiTrackView.mc ./source/TimePicker.mc \
./source/DistancePicker.mc ./source/Timer.mc ./source/Workout.mc \
./source/Menu.mc ./source/TimerInput.mc ./source/Utils.mc;

../bin/monkeyc -r -d fr235 -o ./bin/ultitrack-fr235.prg -m ./manifest.xml -z \
./resources/strings.xml:./resources-fr235/strings.xml:./resources/bitmaps.xml:./resources/resources.xml \
./source/UltiTrackApp.mc ./source/UltiTrackView.mc ./source/TimePicker.mc \
./source/DistancePicker.mc ./source/Timer.mc ./source/Workout.mc \
./source/Menu.mc ./source/TimerInput.mc ./source/Utils.mc;

../bin/monkeyc -o ./bin/ultitrack-emulator.prg -m ./manifest.xml -z \
./resources/strings.xml:./resources/bitmaps.xml:./resources/resources.xml \
./source/UltiTrackApp.mc ./source/UltiTrackView.mc ./source/TimePicker.mc \
./source/DistancePicker.mc ./source/Timer.mc ./source/Workout.mc \
./source/Menu.mc ./source/TimerInput.mc ./source/Utils.mc;

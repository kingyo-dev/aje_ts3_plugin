pushd build
pushd win_x64
cmake -G "Visual Studio 16 2019" -A x64 ../..
popd
popd

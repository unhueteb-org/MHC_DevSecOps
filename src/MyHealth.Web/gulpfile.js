/// <binding BeforeBuild='build, default' Clean='clean' />

var gulp = require('gulp');

require('./gulp/tasks/clean')(gulp);
require('./gulp/tasks/lib')(gulp);
require('./gulp/tasks/lint')(gulp);
require('./gulp/tasks/transpile')(gulp);
require('./gulp/tasks/app')(gulp);
require('./gulp/tasks/sass')(gulp);
require('./gulp/tasks/copy')(gulp);

gulp.task('build', gulp.series(gulp.parallel('copy', 'babel', 'app', 'lib', 'sass')));
gulp.task('build:min', gulp.series(gulp.parallel('copy', 'babel:min', 'app:min', 'lib:min', 'sass:min')));
gulp.task('default', gulp.series(gulp.parallel('build', 'build:min')));

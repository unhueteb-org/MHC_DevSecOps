var paths = require('../options/paths');
var mainBowerFiles = require('main-bower-files');

module.exports = function (gulp) {
    gulp.task('copy:img', function () {
        return gulp.src([mainBowerFiles('**/*.png'), mainBowerFiles('**/*.jpg')])
            .pipe(gulp.dest(paths.dest.images));
    });

    gulp.task('copy:favicon', function () {
        return gulp.src(paths.source.favicon)
            .pipe(gulp.dest(paths.dest.favicon));
    });

    gulp.task('copy:font', function () {
        return gulp.src(paths.source.fonts)
            .pipe(gulp.dest(paths.dest.fonts));
    });

    gulp.task('copy', gulp.parallel('copy:img', 'copy:font', 'copy:favicon'));
};
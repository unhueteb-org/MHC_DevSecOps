var source = require('vinyl-source-stream');
var browserify = require('browserify');
var babelify = require('babelify');
var uglify = require('gulp-uglify');
var paths = require('../options/paths');

module.exports = function (gulp) {
    gulp.task('app:js', function () {
        return browserify('./content/app/app.bootstrapper.js', { debug: true })
            .transform(babelify)
            .bundle()
            .on('error', function (err) { console.log('Error : ' + err.message); })
            .pipe(source(paths.dest.spa.files.js))
            .pipe(gulp.dest(paths.dest.spa.root));
    });

    // TODO: Look how to add uglify here (avoid file.isNull is not defined error).
    gulp.task('app:js:min', function () {
        return browserify('./content/app/app.bootstrapper.js', { debug: true })
            .transform(babelify)
            .bundle()
            .on('error', function (err) { console.log('Error : ' + err.message); })
            .pipe(source(paths.dest.spa.files.jsMin))
            .pipe(gulp.dest(paths.dest.spa.root));
    });

    gulp.task('app:templates', function () {
        return gulp.src(paths.source.spa.templates)
            .pipe(gulp.dest(paths.dest.spa.root));
    });

    gulp.task('app', gulp.parallel('app:js', 'app:templates'));
    gulp.task('app:min', gulp.parallel('app:js:min', 'app:templates'));
};
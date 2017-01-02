var gulp = require('gulp');
var concat = require('gulp-concat');
var zip = require('gulp-zip');
var less = require('gulp-less');

// Create the .rbz archive
gulp.task('rbz_create', function () {
    return gulp.src(
        [

            '../src/**/*'

        ])
        .pipe(zip('maxsyma_dimensions.rbz'))
        .pipe(gulp.dest('../dist'));
});

gulp.task('build', ['rbz_create']);

gulp.task('default', ['build']);
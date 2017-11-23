var gulp = require('gulp'),
    uglify = require('gulp-uglify'),
    cssmin = require('gulp-minify-css'),
    imagemin = require('gulp-imagemin'),
    htmlmin = require('gulp-htmlmin'),
	htmlclean = require('gulp-htmlclean');
	concat = require('gulp-concat');

//图片压缩
gulp.task('images', function() {
    gulp.src('./public/images/*.*')
        .pipe(imagemin({
            progressive: false
        }))
        .pipe(gulp.dest('./public/images/'));
});
//图片压缩
gulp.task('img', function() {
    gulp.src('./public/img/*.*')
        .pipe(imagemin({
            progressive: false
        }))
        .pipe(gulp.dest('./public/img/'));
});
gulp.task('build', [ 'images', 'img']);
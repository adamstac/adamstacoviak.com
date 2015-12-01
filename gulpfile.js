var gulp = require('gulp');
var sass = require('gulp-sass');
var autoprefixer = require('gulp-autoprefixer');
var plumber = require('gulp-plumber');
var options = {};

options.sass = {
  outputStyle: 'expanded'
};

gulp.task('styles', function(){
  return gulp.src('./sass/*.scss')
    .pipe(plumber())
    .pipe(sass(options.sass))
    .pipe(autoprefixer())
    .pipe(gulp.dest('./css'))
});

gulp.task('watch', function() {
  gulp.watch('./sass/**/*.scss', ['styles']);
});

const gulp = require('gulp');
const sass = require('gulp-sass')(require('sass'));
const postcss = require('gulp-postcss');
const autoprefixer = require('autoprefixer');
const cssnano = require('cssnano');
const sourcemaps = require('gulp-sourcemaps');
const log = require('fancy-log');

const sassSourceFile = 'css/app.scss';
const outputFolder = '../priv/static/assets';
const watchedResources = 'css/**/*';

gulp.task('scss', function (done) {
  let stream = gulp.src(sassSourceFile)
    .pipe(sourcemaps.init())
    .pipe(sass().on('error', function(err){
      log.error(err.message);
    }))
    .pipe(postcss([autoprefixer, cssnano]))

  if(process.env.NODE_ENV === 'production') {
    stream = stream.pipe(sourcemaps.write('.'));
  } else {
    stream = stream.pipe(sourcemaps.write());
  }

  stream.pipe(gulp.dest(outputFolder))
    .on('end', done);
});

gulp.task('fonts', function() {
  return gulp.src([
    'node_modules/@fortawesome/fontawesome-free/webfonts/*'])
    .pipe(gulp.dest(`${outputFolder}/webfonts`));
});

gulp.task('watch', gulp.series('scss', 'fonts', function (done) {
  gulp.watch(watchedResources, gulp.parallel('scss'));
  done();
}));

gulp.task('default', gulp.series('watch', function () {}));

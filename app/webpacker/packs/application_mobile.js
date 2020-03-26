/* eslint no-console:0 */

const images = require.context('../images', true)
const imagePath = (name) => images(name, true)

import '../src/javascript/comments.js';
import '../src/javascript/departments.js';
import '../src/javascript/header.js';
import '../src/javascript/settings.js';
import '../src/javascript/users.js';

import '../src/javascript/jquery-week-calendar.js';

import '../src/javascript/mobile/carts_mobile.js';
import '../src/javascript/mobile/courses_mobile.js';
import '../src/javascript/mobile/global_configs.js';

require("@rails/ujs").start()

import 'bootstrap/dist/js/bootstrap';
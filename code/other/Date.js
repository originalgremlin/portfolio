Object.extend(Date, {
    DAY_LONG_UC:         0,
    DAY_LONG_LC:         1,
    DAY_LONG_UCFIRST:    2,
    DAY_SHORT_UC:        3,
    DAY_SHORT_LC:        4,
    DAY_SHORT_UCFIRST:   5,
    
    MONTH_LONG_UC:       0,
    MONTH_LONG_LC:       1,
    MONTH_LONG_UCFIRST:  2,
    MONTH_SHORT_UC:      3,
    MONTH_SHORT_LC:      4,
    MONTH_SHORT_UCFIRST: 5,

    PRETTY_FORMAT: new Template("#{month} #{day}, #{year} at #{hours}:#{minutes} #{ampm}"),


    /*
     * The parseDateTime method takes a mysql, xml, or json date string
     * (such as "YYYY-MM-DD hh:mm:ss") and returns the number
     * of milliseconds since January 1, 1970, 00:00:00 (local time).
     * This function is useful for setting date values based on string
     * values, for example in conjunction with the setTime method and
     * the Date object.  This is based on the static Date.parse(string) method.
     * 
     */
    parseDateTime: function (datetime) {
        if (datetime) {
            var vals = datetime.match(/^(\d{4})-(\d{2})-(\d{2})[tT ](\d{2}):(\d{2}):(\d{2})$/);
            return Date.UTC(vals[1], vals[2] - 1, vals[3], vals[4], vals[5], vals[6]);
        } else {
            return undefined;
        }
    }
});

Object.extend(Date.prototype, {
    // convert a numeric month (0-11) to the name
    // either short (Jan, Feb, Mar) or long (January, February, March)
    getMonthName: function (style) {
        var name;
        // assign name
        switch (this.getMonth()) {
            case 0:  name = 'January';   break;
            case 1:  name = 'February';  break;
            case 2:  name = 'March';     break;
            case 3:  name = 'April';     break;
            case 4:  name = 'May';       break;
            case 5:  name = 'June';      break;
            case 6:  name = 'July';      break;
            case 7:  name = 'August';    break;
            case 8:  name = 'September'; break;
            case 9:  name = 'October';   break;
            case 10: name = 'November';  break;
            case 11: name = 'December';  break;
            default: break;
        }
        // convert name
        switch (style) {
            case Date.MONTH_LONG_UC:
                name = name.toUpperCase();
                break;
            case Date.MONTH_LONG_LC:
                name = name.toLowerCase();
                break;
            case Date.MONTH_LONG_UCFIRST:
                name = name;
                break;
            case Date.MONTH_SHORT_UC:
                name = name.toUpperCase().slice(0, 3);
                break;
            case Date.MONTH_SHORT_LC:
                name = name.toLowerCase().slice(0, 3);
                break;
            case Date.MONTH_SHORT_UCFIRST:
            default:
                name = name.slice(0, 3);
                break;
        }
        // return name
        return name;
    },

    // convert a numeric day (0-6) to the name
    // either short (Sun, Mon, Tue) or long (Sunday, Monday, Tuesday)
    getDayName: function (style) {
        var name;
        // assign name
        switch (this.getDay()) {
            case 0:  name = 'Sunday';    break;
            case 1:  name = 'Monday';    break;
            case 2:  name = 'Tuesday';   break;
            case 3:  name = 'Wednesday'; break;
            case 4:  name = 'Thursday';  break;
            case 5:  name = 'Friday';    break;
            case 6:  name = 'Saturday';  break;
            default: break;
        }
        // convert name
        switch (style) {
            case Date.DAY_LONG_UC:
                name = name.toUpperCase();
                break;
            case Date.DAY_LONG_LC:
                name = name.toLowerCase();
                break;
            case Date.DAY_LONG_UCFIRST:
                name = name.toLowerCase();
                break;
            case Date.DAY_SHORT_UC:
                name = name.toUpperCase().slice(0, 3);
                break;
            case Date.DAY_SHORT_LC:
                name = name.toLowerCase().slice(0, 3);
                break;
            case Date.DAY_SHORT_UCFIRST:
            default:
                name = name.toLowerCase().slice(0, 3);
                break;
        }
        // return name
        return name;
    },

    toPrettyString: function () {
        var year    = this.getFullYear();
        var month   = this.getMonthName(Date.MONTH_LONG_UCFIRST);
        var day     = this.getDate().toString();
        var hours   = (this.getHours() % 12).toString();
        var minutes = this.getMinutes().toString();
        var seconds = this.getSeconds().toString();
        var ampm    = this.getHours() < 12 ? 'AM' : 'PM';

        return Date.PRETTY_FORMAT.evaluate({
            year:    year,
            month:   month,
            day:     day,
            hours:   (hours.length > 1   ? hours   : "0" + hours),
            minutes: (minutes.length > 1 ? minutes : "0" + minutes),
            seconds: (seconds.length > 1 ? seconds : "0" + seconds),
            ampm:    ampm
        });
    }
});
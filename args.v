/**
 * V-Args 0.1.2
 * https://github.com/nedpals/v-args
 * 
 * (c) 2019 Ned Palacios and its contributors.
 */

module args

struct Args {
pub mut:
    command string
    options map[string]string
    unknown []string
}

fn parse_hypen_args(v string) []string {
    mut delimitter := '-'

    if v.starts_with('--') {
        delimitter = '--'
    }

    val := v.replace(delimitter, '')

    return val.split('=')
}

fn detect_hypen_args(v string) bool {
    return v.starts_with('-')
}

pub fn parse(a []string) Args {
    args := a.slice(1, a.len)

    mut parsed := Args{'', map[string]string{}, []string}

    for i := 0; i < args.len; i++ {

        prev := if i-1 <= 0 { '' } else { args[i-1] }
        current := args[i]
        noHypens := !detect_hypen_args(prev) && !detect_hypen_args(current)
        
        if i == 0 && !detect_hypen_args(current) {
                parsed.command = current
            }

        if detect_hypen_args(prev) {
            prevArg := parse_hypen_args(prev)
            parsed.options[prevArg[0]] = current
        }

        if i != 0 && noHypens {
            parsed.unknown << current
        }

        if detect_hypen_args(current) {
            arg := parse_hypen_args(string(current))
            mut val := ''

            if arg.len == 2 {
                parsed.options[arg[0]] = arg[1]
    }

            if arg.len == 1 && next.len == 0 {
                parsed.options[arg[0]] = ''
}
        }
    }

    return parsed
}

pub fn (v Args) str() string {
    opts_str := v.options.str().split('\n').join(' ')

    return '\{ command: ${v.command}, options: ${opts_str}, unknown: ${v.unknown.str()} \}'
}
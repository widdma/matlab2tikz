function [stage, errorHasOccurred] = errorHandler(e)
% common error handler code: save and print to console
    errorHasOccurred = true;
    stage = emptyStage();
    stage.message = format_error_message(e);
    stage.error   = errorHasOccurred;

    disp_error_message(stage.message);
end
% ==============================================================================
function msg = format_error_message(e)
    msg = '';
    if ~isempty(e.message)
        msg = sprintf('%serror: %s\n', msg, e.message);
    end
    if ~isempty(e.identifier)
        if strfind(lower(e.identifier),'testmatlab2tikz:')
            % When "errors" occur in the test framework, i.e. a hash mismatch
            % or no hash provided, there is no need to be very verbose.
            % So we don't return the msgid and the stack trace in those cases!
            return % only return the message
        end
        msg = sprintf('%serror: %s\n', msg, e.identifier);
    end
    if ~isempty(e.stack)
        msg = sprintf('%serror: called from:\n', msg);
        for ee = e.stack(:)'
            msg = sprintf('%serror:   %s at line %d, in function %s\n', ...
                          msg, ee.file, ee.line, ee.name);
        end
    end
end
% ==============================================================================
function disp_error_message(msg)
    stderr = 2;
    % When displaying the error message in MATLAB, all backslashes
    % have to be replaced by two backslashes. This must not, however,
    % be applied constantly as the string that's saved to the LaTeX
    % output must have only one backslash.
    switch getEnvironment
        case 'MATLAB'
            fprintf(stderr, strrep(msg, '\', '\\'));
        case 'Octave'
            fprintf(stderr, msg);
    end
end
% ==============================================================================

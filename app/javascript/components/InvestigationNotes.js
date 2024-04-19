import React from "react";
import PropTypes from "prop-types";
import Select from "react-select";
import { find } from "lodash";
import { get, post } from "../api";
import FormattedDate from "./FormattedDate";
import StringInput from "./StringInput";

function NoteEditor({ close, onSave }) {
    const [noteContent, setNoteContent] = React.useState('');
  
    return (
      <>
        <StringInput value={noteContent} setValue={setNoteContent}
        />
        <button onClick={() => onSave(noteContent)} disabled={!noteContent}>
          Save
        </button>{" "}
        <button onClick={close}>Cancel</button>
      </>
    );
  }
  
  NoteEditor.propTypes = {
    close: PropTypes.func.isRequired,
    onSave: PropTypes.func.isRequired,
  };

function InvestigationNotes({ notes, investigationId }) {
  const [editorOpen, setEditorOpen] = React.useState(false);
  const [currentNotes, setCurrentNotes] = React.useState(notes);

  function onSave(newNote) {
    // const newNoteId = currentNotes.reduce((max, note) => (note.id > max ? note.id : max), 0) + 1;
    post(`/v1/investigations/${investigationId}/notes`, {
      investigation_note: {
        content: newNote,
      },
    }).then((result) => {
      setEditorOpen(false);
      setCurrentNotes([result].concat(currentNotes));
    });
  }

  const content =
    currentNotes.length === 0 ? (
      <p>This investigation does not yet have notes associated with it.</p>
    ) : (
      <>
        <ul>
          {currentNotes.map((note) => {
            const { officer, date, content } = note.data.attributes;
            const {first_name, last_name} = officer.data.attributes;
            return (
              <li key={`note-${note.data.id}`}>
                <p>
                    {FormattedDate(date)}: {content} <br/>
                    - {first_name} {last_name} 
                </p>
              </li>
            );
          })}
        </ul>
      </>
    );

  return (
    <>
      <div class="card blue lighten-5">
        <div class="card-content">
          <span class="card-title">Investigation Notes</span>
            {content}
            {editorOpen && (
              <NoteEditor
                close={() => setEditorOpen(false)}
                onSave={onSave}
              />
            )}
            {!editorOpen && <button onClick={() => setEditorOpen(true)}>Add</button>}
        </div>
      </div>
    </>
  );
}

InvestigationNotes.propTypes = {
  notes: PropTypes.arrayOf(PropTypes.object).isRequired,
  investigationId: PropTypes.string.isRequired,
};

export default InvestigationNotes;
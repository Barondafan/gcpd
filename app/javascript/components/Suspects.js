import React from "react";
import PropTypes from "prop-types";
import Select from "react-select";
import { find } from "lodash";
import { get, post } from "../api";
import FormattedDate from "./FormattedDate";

function CrimeEditor({ close, onSave, currentCrimes }) {
  const [options, setOptions] = React.useState([]);
  const [crimeId, setCrimeId] = React.useState();

  React.useEffect(() => {
    get(`/v1/crimes`).then((response) => {
      setOptions(
        response.crimes.map((crime) => {
          const crimeAlreadyExists = !!find(currentCrimes, {
            data: { id: crime.data.id },
          });
          const { name, felony } = crime.data.attributes;
          return {
            value: crime.data.id,
            label: `${name} (${felony ? "felony" : "misdemeanor"})`,
            disabled: crimeAlreadyExists,
          };
        })
      );
    });
  }, []);

  return (
    <>
      <Select
        options={options}
        onChange={({ value }) => setCrimeId(value)}
        isOptionDisabled={(option) => option.disabled}
      />
      <button onClick={() => onSave(crimeId)} disabled={!crimeId}>
        Save
      </button>{" "}
      <button onClick={close}>Cancel</button>
    </>
  );
}

CrimeEditor.propTypes = {
  close: PropTypes.func.isRequired,
  onSave: PropTypes.func.isRequired,
  currentCrimes: PropTypes.arrayOf(PropTypes.object).isRequired,
};

function Suspects({ suspects, investigationId }) {
  const [editorOpen, setEditorOpen] = React.useState(false);
  const [currentSuspects, setCurrentSuspects] = React.useState(suspects);

  function onSave(criminalId) {
    post(`/v1/investigations/${investigationId}/crime_investigations`, {
      crime_investigation: {
        criminal_id: criminalId,
      },
    }).then((result) => {
      setEditorOpen(false);
      setCurrentCrimes([result].concat(currentSuspects));
    });
  }

  const content =
    currentSuspects.length === 0 ? (
      <p>This investigation does not yet have suspects associated with it.</p>
    ) : (
      <>
        <ul>
          {currentSuspects.map((suspect) => {
            const { criminal, added_on, dropped_on } = suspect.data.attributes;
            const {first_name, last_name} = criminal.data.attributes;
            return (
              <li key={`suspect-${suspect.data.id}`}>
                <p> 
                    <i>{first_name} {last_name}</i> <br/>  
                    <ul>
                        <li>&#x2022; Added: {FormattedDate(added_on)}</li>
                        <li>&#x2022; Dropped: {dropped_on ? FormattedDate(dropped_on) : "N/A"}</li> 
                    </ul>
                </p>
              </li>
            );
          })}
        </ul>
      </>
    );
  return (
    <>
      <div class="card yellow lighten-5">
        <div class="card-content">
          <span class="card-title">Suspects</span>
            {content}

        </div>
      </div>
    </>
  );
}

Suspects.propTypes = {
  suspects: PropTypes.arrayOf(PropTypes.object).isRequired,
  investigationId: PropTypes.string.isRequired,
};

export default Suspects;
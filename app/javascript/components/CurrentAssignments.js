import React from "react";
import PropTypes from "prop-types";
import FormattedDate from "./FormattedDate";

function CurrentAssignments({ assignments }) {
  if (!assignments) {
    return <div>Loading assignments...</div>;
  }

  return (
    <div class="card yellow lighten-5">
      <div class="card-content">
        <span class="card-title">Current Assignments</span>
        {assignments.length === 0 ? (
          <p>This investigation does not yet have current assignments associated with it.</p>
        ) : (
          <ul>
          {assignments.map((assignment) => {
            const { officer, start_date } = assignment.data.attributes;
            const {first_name, last_name, rank} = officer.data.attributes;
            return (
              <li key={`assignment-${assignment.data.id}`}>
                <p>
                  - {rank} {first_name} {last_name} (as of: {FormattedDate(start_date)})
                </p>
              </li>
            );
          })}
        </ul>
        )}
      </div>
    </div>
  );
}

CurrentAssignments.propTypes = {
  assignments: PropTypes.arrayOf(PropTypes.object).isRequired,
};

export default CurrentAssignments;
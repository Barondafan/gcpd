import React from "react";
import PropTypes from "prop-types";
import { get } from "../api";
import InvestigationOverview from "./InvestigationOverview";
import Crimes from "./Crimes";

function Investigation({ investigationId }) {
  const [investigation, setInvestigation] = React.useState();

  // load investigation data
  React.useEffect(() => {
    get(`/v1/investigations/${investigationId}`).then((response) => {
      console.log(response);
      setInvestigation(response);
    });
  }, [investigationId, setInvestigation]);

  if (!investigation) {
    return <>loading...</>;
  }

  const investigationData = investigation.data.attributes;

  return (
    <>
      <h4>
        Investigation #{investigation.data.id}: {investigationData.title}
      </h4>

      <div class="row">
        <div class="col s6">
          {/* first component */}
          <InvestigationOverview investigation={investigation} />
        </div>
        <div class="col s6">
          {/* second component */}
          <Crimes
            crimes={investigationData.crimes}
            investigationId={investigationId}
          />
        </div>  
      </div>

      
      
    </>
  );
}

Investigation.propTypes = {
  investigationId: PropTypes.string.isRequired,
};
export default Investigation;

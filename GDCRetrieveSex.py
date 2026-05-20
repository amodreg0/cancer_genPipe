import argparse
import json

import requests as requests


def retrieve(case_uuid: str) -> str:
    url = 'https://api.gdc.cancer.gov/cases'
    myobj = {
        'format': 'json',
        'fields': 'case_id',
        'filters': '{{"content":[{{"content":{{"field":"cases.case_id","value":["{0}"]}},"op":"in"}}],"op":"and"}}'.format(case_uuid),
        'expand': 'demographic,diagnoses,diagnoses.treatments,exposures,family_histories,follow_ups,follow_ups.molecular_tests',
        'pretty': 'true'
    }

    r = requests.post(url, data = myobj)
    result = json.loads(r.content)
    gender = result['data']['hits'][0]['demographic']['gender']

    return gender


# Press the green button in the gutter to run the script.
if __name__ == '__main__':
    ap = argparse.ArgumentParser(description="Retrieve sex from GDC based on case uuid")

    ap.add_argument("-c", "--caseUuid", required=True)

    args = vars(ap.parse_args())
    print(retrieve(args['caseUuid']))


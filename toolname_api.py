#!/usr/bin/env python3
__doc__ = """

Title - One line blurb

Paragraph describing

Usage:
    ./projectmain.py arg1 [optionalarg2]

Parameters
    param1          Thing 1 (required). 6 chars starting with Thing
    param2          Thing 2 (optional)

Output:
    string_output   Thing 3.  6 chars starting with Thing

Examples:
    ./projectmain.py                    Will prompt for all arguments
    ./projectmain.py Thing1             Will prompt for 1 argument
    ./projectmain.py Thing1 Thing2      Will execute and return Thing 3
    ./projectmain.py help               Will output this help doc

"""
__author__ = "epopisces"
__date__ = "2020.12.06"
__version__ = 0.1

import logging, requests, json, os, time, argparse
from requests.exceptions import RequestException
# import toml # used to parse config file

#from tools.toolname import toolname_api as tool

class TOOLNAMEAPIException(Exception):
    pass

class TOOLNAMENotFoundException(Exception):
    pass

class TOOLNAMEGeneralException(Exception):
    pass

class TOOLNAMEInvalidInputException(Exception):
    pass


class ObjectClass():
    """A quick description of the class

    Attributes:
        var1 (bool):          used for this thing
        var2 (str, optional): used for that thing
    """

    # TODO: Update methods_supported to be accurate according to what is supported by this API
    methods_supported = ["POST","GET"] 
    # TODO: Update base_url
    base_url = ""

    def __init__(self, var1, var2=False):
        self.var1 = var1
        self.var2 = var2

        # maybe call another function here to help setup things

        return

    def this_func(self):
        # do the thing here
        return

    def _request(self, api_path, method, params=None, headers=None, body=None, post_param=None):
        """ unpaged request template, abstracts much of the error handling.  
        May require modification for specific API to account for idiosyncrasies 
        """
    
        method = method.upper() # just in case (puns!)
        
        if method not in self.methods_supported:
            raise TOOLNAMEAPIException(f"{method} is not a HTTP method supported by this API")

        #* Make any method-dependent alterations here, eg add Content-type to headers for POST

        try:
            session = requests.Session() # using a session persists params, cookies across reqs

            session.mount(self.base_url, requests.adapters.HTTPAdapter(max_retries=3)) #? override default session retries
            if body:
                #* add auth= to below if needed for API auth
                request = requests.Request(method, self.base_url + api_path, params=params, headers=headers, json=body)
            else:
                request = requests.Request(method, self.base_url + api_path, params=params, headers=headers)

            # https://docs.python-requests.org/en/latest/user/advanced/#prepared-requests
            prepared_request = session.prepare_request(request)

            #* Here is the spot where the prepp'd content can be modified, if need be

            r = session.send(prepared_request)
        
        except requests.exceptions.RequestException as e:
            logging.exception("Connection error")
            raise TOOLNAMEAPIException(e)

        # handle status codes in response        
        if not (r.status_code == requests.codes.ok):
            if r.status_code == 204:
                return r.status_code
            else:
                print("Error retrieving data.  HTTP status code: {}".format(r.status_code))
            if r.status_code == 401:
                print("Check that your API credentials are correct.")
            else:
                logging.exception(f"Error: {r.text} for request {r.request_url}")
            raise requests.exceptions.RequestException()
        else:
            try:
                return r.json()
            except json.JSONDecodeError:
                return r.text

    def _paged_request(self, api_path, method, hal_element, params=None, headers=None, body=None, post_param=None):
        """ paged request template, still a work in progress.
        A given APIs may implement pagination very differently from another API
        May require modification for specific API to account for idiosyncrasies 
        """
        all_data = []
        page = 0
        more_pages = True

        method = method.upper() # just in case (puns!)
        
        if method not in self.methods_supported:
            raise TOOLNAMEAPIException(f"{method} is not a HTTP method supported by this API")

        #* Make any method-dependent alterations here, eg add Content-type to headers for POST

        while more_pages:
            params['page'] = page
            page_data = self._request(api_path, method, params, headers, body, post_param)
            #! assumes req returns total_pages field, mod as needed
            total_pages = page_data.get('page', {}).get('total_pages', 0)
            #! assumes API is using HAL _embedded format
            this_page_data = page_data.get('_embedded', {}).get(hal_element, [])
            all_data += this_page_data

            page += 1
            more_pages = page < total_pages

        return all_data
        

if __name__ == "__main__":
    #? Remove this section if not accepting arguments from CLI
    #region #####=-   Argparse                                                ##########
    parser = argparse.ArgumentParser(description='short description of the module')
    parser.add_argument('-v','--var2', default=False, type=str, help='describe arg for when man or help is used')
    parser.add_argument('--var1', action='store_true', help='describe arg for when man or help is used')

    args = parser.parse_args()
    #endregion

    # Uncomment for testing setup   
    var1 = True
    oc = ObjectClass(var1, var2=args.var2)
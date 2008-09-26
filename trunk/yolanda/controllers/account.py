import logging
from yolanda.lib.base import *
from openid.consumer.consumer import Consumer, SUCCESS, FAILURE, DiscoveryFailure

log = logging.getLogger(__name__)

class AccountController(BaseController):
    def __before__(self):
        self.openid_session = session.get("openid_session", {})

    # @validate(schema=something, form='login')
    def login(self):
        #FIXME: do not operate in stateless mode - replace store with local
        # openid store (app global) to make login faster with less overhead
        self.consumer = Consumer(self.openid_session, None)
        openid = request.params.get('username', None)
        try:
            authrequest = self.consumer.begin(openid)
        except DiscoveryFailure, e:
            # invalid openid
            c.message = {
                        'type': 'error',
                        'text': 'You were not logged on due to entering an invalid OpenID.'
                        }
            return render('/xhtml/index.mako')

        redirecturl = authrequest.redirectURL(
            h.url_for('',qualified=True),
            return_to=h.url_for('/account/verified',qualified=True),
            immediate=False
        )
        session['openid_session'] = self.openid_session
        session.save()
        return redirect_to(redirecturl)
    
    def verified(self):
        #FIXME: do not operate in stateless mode - replace store with local
        # openid store (app global) to make login faster with less overhead
        self.consumer = Consumer(self.openid_session, None)
        info = self.consumer.complete(request.params, (h.url_for('/account/verified', qualified=True)))
        if info.status == SUCCESS:
            session['openid'] = info.identity_url
            session.save()
            session.clear()
            return redirect_to('/index')
        else:
            return "openid auth error"

    def logout(self):
        session.clear()
        session.save()
        return redirect_to('/index')


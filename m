From: Lukasz Pawelczyk <l.pawelczyk@samsung.com>
Subject: Re: [PATCH v2 0/7] Smack namespace
Date: Wed, 27 May 2015 11:36:12 +0200
Message-ID: <1432719372.1784.4.camel@samsung.com>
References: <1432209222-8479-1-git-send-email-l.pawelczyk@samsung.com>
 <1432557162-19123-1-git-send-email-l.pawelczyk@samsung.com>
 <556484BD.2060004@tycho.nsa.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-doc-owner@vger.kernel.org>
In-reply-to: <556484BD.2060004@tycho.nsa.gov>
Sender: linux-doc-owner@vger.kernel.org
To: Stephen Smalley <sds@tycho.nsa.gov>
Cc: "David S. Miller" <davem@davemloft.net>, "Eric W. Biederman" <ebiederm@xmission.com>, "Kirill A. Shutemov" <kirill@shutemov.name>, "Serge E. Hallyn" <serge@hallyn.com>, Al Viro <viro@zeniv.linux.org.uk>, Alexey Dobriyan <adobriyan@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Andy Lutomirski <luto@amacapital.net>, Casey Schaufler <casey@schaufler-ca.com>, David Howells <dhowells@redhat.com>, Fabian Frederick <fabf@skynet.be>, Greg KH <gregkh@linuxfoundation.org>, James Morris <james.l.morris@oracle.com>, Jeff Layton <jlayton@primarydata.com>, Jingoo Han <jg1.han@samsung.com>, Joe Perches <joe@perches.com>, John Johansen <john.johansen@canonical.com>, Jonathan Corbet <corbet@lwn.net>, Kees Cook <keescook@chromium.org>, Mauro Carvalho Chehab <mchehab@osg.samsung.com>, Miklos Szeredi <miklos@szeredi.hu>, Oleg Nesterov <oleg@redhat.com>, Paul Moore <paul@pa>
List-Id: linux-api@vger.kernel.org

On wto, 2015-05-26 at 10:35 -0400, Stephen Smalley wrote:
> On 05/25/2015 08:32 AM, Lukasz Pawelczyk wrote:
> > --- Usage ---
> > 
> > Smack namespace is written using LSM hooks inside user namespace. That
> > means it's connected to it.
> > 
> > To create a new Smack namespace you need to unshare() user namespace
> > as usual. If that is all you do though, than there is no difference to
> > what is now. To activate the Smack namespace you need to fill the
> > labels' map. It is in a file /proc/$PID/smack_map.
> 
> This should be /proc/$PID/attr/label_map or similar, modeled after the
> existing /proc/$PID/attr/current and similar nodes.  Then it isn't
> module-specific and can be reused for other modules.

To make this generic I'll have to introduce new LSH hooks to handle this
file (much like /proc/$PID/attr/current).
I take this is what you had in mind.


-- 
Lukasz Pawelczyk
Samsung R&D Institute Poland
Samsung Electronics




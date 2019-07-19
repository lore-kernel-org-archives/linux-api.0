From: Burn Alting <burn.alting@iinet.net.au>
Subject: Re: [PATCH ghak90 V6 02/10] audit: add container id
Date: Sat, 20 Jul 2019 08:41:52 +1000
Message-ID: <dc25084d1a408eeb6d4e49cc9037b37064d08c3d.camel@iinet.net.au>
References: <20190529153427.GB8959@cisco>
	<CAHC9VhSF3AjErX37+eeusJ7+XRw8yuPsmqBTRwc9EVoRBh_3Tw@mail.gmail.com>
	<20190529222835.GD8959@cisco>
	<CAHC9VhRS66VGtug3fq3RTGHDvfGmBJG6yRJ+iMxm3cxnNF-zJw@mail.gmail.com>
	<20190530170913.GA16722@mail.hallyn.com>
	<CAHC9VhThLiQzGYRUWmSuVfOC6QCDmA75BDB7Eg7V8HX4x7ymQg@mail.gmail.com>
	<20190708180558.5bar6ripag3sdadl@madcap2.tricolour.ca>
	<CAHC9VhRTT7JWqNnynvK04wKerjc-3UJ6R1uPtjCAPVr_tW-7MA@mail.gmail.com>
	<20190716220320.sotbfqplgdructg7@madcap2.tricolour.ca>
	<CAHC9VhScHizB2r5q3T5s0P3jkYdvzBPPudDksosYFp_TO7W9-Q@mail.gmail.com>
	<20190718005145.eshekqfr3navqqiy@madcap2.tricolour.ca>
	<CAHC9VhTYV02ws3QcezER5cY+Xt+tExcJEO-dumTDx=FXGFh3nw@mail.gmail.com>
	<87muhadnfr.fsf@xmission.com>
Reply-To: burn@swtf.dyndns.org
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============9134558627751912770=="
Return-path: <linux-audit-bounces@redhat.com>
In-Reply-To: <87muhadnfr.fsf@xmission.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/linux-audit>,
	<mailto:linux-audit-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/linux-audit>
List-Post: <mailto:linux-audit@redhat.com>
List-Help: <mailto:linux-audit-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/linux-audit>,
	<mailto:linux-audit-request@redhat.com?subject=subscribe>
Sender: linux-audit-bounces@redhat.com
Errors-To: linux-audit-bounces@redhat.com
To: "Eric W. Biederman" <ebiederm@xmission.com>, Paul Moore <paul@paul-moore.com>
Cc: Tycho Andersen <tycho@tycho.ws>, nhorman@tuxdriver.com, Richard, Briggs <rgb@redhat.com>, linux-api@vger.kernel.org, containers@lists.linux-foundation.org, LKML <linux-kernel@vger.kernel.org>, dhowells@redhat.com, Linux-Audit Mailing List <linux-audit@redhat.com>, netfilter-devel@vger.kernel.org, simo@redhat.com, netdev@vger.kernel.org, linux-fsdevel@vger.kernel.org, Eric Paris <eparis@parisplace.org>, "Serge E. Hallyn" <serge@hallyn.com>
List-Id: linux-api@vger.kernel.org


--===============9134558627751912770==
Content-Type: multipart/alternative; boundary="=-CxgK95SBwuyC3/A2B9eg"


--=-CxgK95SBwuyC3/A2B9eg
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit

On Fri, 2019-07-19 at 11:00 -0500, Eric W. Biederman wrote:
> Paul Moore <paul@paul-moore.com> writes:
> 
> 
> On Wed, Jul 17, 2019 at 8:52 PM Richard Guy Briggs <rgb@redhat.com> wrote:
> 
> On 2019-07-16 19:30, Paul Moore wrote:
> 
> ...
> 
> 
> 
> We can trust capable(CAP_AUDIT_CONTROL) for enforcing audit container
> ID policy, we can not trust ns_capable(CAP_AUDIT_CONTROL).
> 
> Ok.  So does a process in a non-init user namespace have two (or more)
> sets of capabilities stored in creds, one in the init_user_ns, and one
> in current_user_ns?  Or does it get stripped of all its capabilities in
> init_user_ns once it has its own set in current_user_ns?  If the former,
> then we can use capable().  If the latter, we need another mechanism, as
> you have suggested might be needed.
> 
> Unfortunately I think the problem is that ultimately we need to allow
> any container orchestrator that has been given privileges to manage
> the audit container ID to also grant that privilege to any of the
> child process/containers it manages.  I don't believe we can do that
> with capabilities based on the code I've looked at, and the
> discussions I've had, but if you find a way I would leave to hear it.
> 
> 
> 
> If some random unprivileged user wants to fire up a container
> orchestrator/engine in his own user namespace, then audit needs to be
> namespaced.  Can we safely discard this scenario for now?
> 
> I think the only time we want to allow a container orchestrator to
> manage the audit container ID is if it has been granted that privilege
> by someone who has that privilege already.  In the zero-container, or
> single-level of containers, case this is relatively easy, and we can
> accomplish it using CAP_AUDIT_CONTROL as the privilege.  If we start
> nesting container orchestrators it becomes more complicated as we need
> to be able to support granting and inheriting this privilege in a
> manner; this is why I suggested a new mechanism *may* be necessary.
> 
> 
> Let me segway a bit and see if I can get this conversation out of the
> rut it seems to have drifted into.
> 
> Unprivileged containers and nested containers exist today and are going
> to become increasingly common.  Let that be a given.
> 
> As I recall the interesting thing for audit to log is actions by
> privileged processes.  Audit can log more but generally configuring
> logging by of the actions of unprivileged users is effectively a self
> DOS.
> 
> So I think the initial implementation can safely ignore actions of
> nested containers and unprivileged containers because you don't care
> about their actions. 
> 
> If we start allow running audit in a container then we need to deal with
> all of the nesting issues but until then I don't think you folks care.
> 
> Or am I wrong.  Do the requirements for securely auditing things from
> the kernel care about the actions of unprivileged users?

Depending on the sensitivity of the information the host or system manages, yes the
actions of
unprivileged users is important to security auditing. Kernel auditing sometimes is
the only opportunity
an incident responder has to identify a user's (privileged or not) interaction with
the data the host manages.

> 
> Eric
> 
> --
> Linux-audit mailing list
> Linux-audit@redhat.com
> https://www.redhat.com/mailman/listinfo/linux-audit
> 

--=-CxgK95SBwuyC3/A2B9eg
Content-Type: text/html; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

<html dir=3D"ltr"><head></head><body style=3D"text-align:left; direction:lt=
r;"><div>On Fri, 2019-07-19 at 11:00 -0500, Eric W. Biederman wrote:</div><=
blockquote type=3D"cite" style=3D"margin:0 0 0 .8ex; border-left:2px #729fc=
f solid;padding-left:1ex"><pre>Paul Moore &lt;<a href=3D"mailto:paul@paul-m=
oore.com">paul@paul-moore.com</a>&gt; writes:</pre><pre><br></pre><pre></pr=
e><pre>On Wed, Jul 17, 2019 at 8:52 PM Richard Guy Briggs &lt;<a href=3D"ma=
ilto:rgb@redhat.com">rgb@redhat.com</a>&gt; wrote:</pre><pre></pre><pre>On =
2019-07-16 19:30, Paul Moore wrote:</pre><pre><br></pre><pre>...</pre><pre>=
<br></pre><pre></pre><pre></pre><pre>We can trust capable(CAP_AUDIT_CONTROL=
) for enforcing audit container</pre><pre>ID policy, we can not trust ns_ca=
pable(CAP_AUDIT_CONTROL).</pre><pre><br></pre><pre>Ok.  So does a process i=
n a non-init user namespace have two (or more)</pre><pre>sets of capabiliti=
es stored in creds, one in the init_user_ns, and one</pre><pre>in current_u=
ser_ns?  Or does it get stripped of all its capabilities in</pre><pre>init_=
user_ns once it has its own set in current_user_ns?  If the former,</pre><p=
re>then we can use capable().  If the latter, we need another mechanism, as=
</pre><pre>you have suggested might be needed.</pre><pre><br></pre><pre>Unf=
ortunately I think the problem is that ultimately we need to allow</pre><pr=
e>any container orchestrator that has been given privileges to manage</pre>=
<pre>the audit container ID to also grant that privilege to any of the</pre=
><pre>child process/containers it manages.  I don't believe we can do that<=
/pre><pre>with capabilities based on the code I've looked at, and the</pre>=
<pre>discussions I've had, but if you find a way I would leave to hear it.<=
/pre><pre><br></pre><pre></pre><pre></pre><pre>If some random unprivileged =
user wants to fire up a container</pre><pre>orchestrator/engine in his own =
user namespace, then audit needs to be</pre><pre>namespaced.  Can we safely=
 discard this scenario for now?</pre><pre><br></pre><pre>I think the only t=
ime we want to allow a container orchestrator to</pre><pre>manage the audit=
 container ID is if it has been granted that privilege</pre><pre>by someone=
 who has that privilege already.  In the zero-container, or</pre><pre>singl=
e-level of containers, case this is relatively easy, and we can</pre><pre>a=
ccomplish it using CAP_AUDIT_CONTROL as the privilege.  If we start</pre><p=
re>nesting container orchestrators it becomes more complicated as we need</=
pre><pre>to be able to support granting and inheriting this privilege in a<=
/pre><pre>manner; this is why I suggested a new mechanism *may* be necessar=
y.</pre><pre><br></pre><pre><br></pre><pre>Let me segway a bit and see if I=
 can get this conversation out of the</pre><pre>rut it seems to have drifte=
d into.</pre><pre><br></pre><pre>Unprivileged containers and nested contain=
ers exist today and are going</pre><pre>to become increasingly common.  Let=
 that be a given.</pre><pre><br></pre><pre>As I recall the interesting thin=
g for audit to log is actions by</pre><pre>privileged processes.  Audit can=
 log more but generally configuring</pre><pre>logging by of the actions of =
unprivileged users is effectively a self</pre><pre>DOS.</pre><pre><br></pre=
><pre>So I think the initial implementation can safely ignore actions of</p=
re><pre>nested containers and unprivileged containers because you don't car=
e</pre><pre>about their actions. </pre><pre><br></pre><pre>If we start allo=
w running audit in a container then we need to deal with</pre><pre>all of t=
he nesting issues but until then I don't think you folks care.</pre><pre><b=
r></pre><pre>Or am I wrong.  Do the requirements for securely auditing thin=
gs from</pre><pre>the kernel care about the actions of unprivileged users?<=
/pre></blockquote><div><br></div><div>Depending on the sensitivity of the i=
nformation the host or system manages, yes the actions of</div><div>unprivi=
leged users is important to security auditing. Kernel auditing sometimes is=
 the only opportunity</div><div>an incident responder has to identify a use=
r's (privileged or not) interaction with the data the host manages.</div><d=
iv><br></div><blockquote type=3D"cite" style=3D"margin:0 0 0 .8ex; border-l=
eft:2px #729fcf solid;padding-left:1ex"><pre><br></pre><pre>Eric</pre><pre>=
<br></pre><pre>--</pre><pre>Linux-audit mailing list</pre><pre><a href=3D"m=
ailto:Linux-audit@redhat.com">Linux-audit@redhat.com</a></pre><pre><a href=
=3D"https://www.redhat.com/mailman/listinfo/linux-audit">https://www.redhat=
.com/mailman/listinfo/linux-audit</a></pre><pre><br></pre></blockquote></bo=
dy></html>

--=-CxgK95SBwuyC3/A2B9eg--


--===============9134558627751912770==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============9134558627751912770==--

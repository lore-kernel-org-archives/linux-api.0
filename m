From: Aleksa Sarai <cyphar@cyphar.com>
Subject: Re: [PATCH v1 2/2] signal: add procfd_signal() syscall
Date: Tue, 20 Nov 2018 08:36:08 +1100
Message-ID: <20181119213608.fym3gpo7fdmyv6rm@yavin>
References: <20181119103241.5229-1-christian@brauner.io>
 <20181119103241.5229-3-christian@brauner.io>
 <20181119202857.k5zw742xjfrw677j@yavin>
 <20181119205518.btew3vxwgva4w3zh@brauner.io>
 <20181119211810.73ptfhnwdmkngfi4@yavin>
 <20181119212126.u2nkijmula6wcfqi@brauner.io>
 <CAKOZuevEx6CbcxrR8eVZrUXDcN5y1GPsXdSoHfQteSQKypx0qw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="thafhy42vzv3dibt"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAKOZuevEx6CbcxrR8eVZrUXDcN5y1GPsXdSoHfQteSQKypx0qw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Daniel Colascione <dancol@google.com>
Cc: Christian Brauner <christian@brauner.io>, "Eric W. Biederman" <ebiederm@xmission.com>, linux-kernel <linux-kernel@vger.kernel.org>, "Serge E. Hallyn" <serge@hallyn.com>, Jann Horn <jannh@google.com>, Andy Lutomirski <luto@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Tim Murray <timmurray@google.com>, linux-man <linux-man@vger.kernel.org>, Kees Cook <keescook@chromium.org>
List-Id: linux-api@vger.kernel.org


--thafhy42vzv3dibt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2018-11-19, Daniel Colascione <dancol@google.com> wrote:
> On Mon, Nov 19, 2018 at 1:21 PM, Christian Brauner <christian@brauner.io>=
 wrote:
> > That can be done without a loop by comparing the level counter for the
> > two pid namespaces.
> >
> >>
> >> And you can rewrite pidns_get_parent to use it. So you would instead be
> >> doing:
> >>
> >>     if (pidns_is_descendant(proc_pid_ns, task_active_pid_ns(current)))
> >>         return -EPERM;
> >>
> >> (Or you can just copy the 5-line loop into procfd_signal -- though I
> >> imagine we'll need this for all of the procfd_* APIs.)
>=20
> Why is any of this even necessary? Why does the child namespace we're
> considering even have a file descriptor to its ancestor's procfs? If
> it has one of these FDs, it can already *read* all sorts of
> information it really shouldn't be able to acquire, so the additional
> ability to send a signal (subject to the usual permission checks)
> feels like sticking a finger in a dike that's already well-perforated.
> IMHO, we shouldn't bother with this check. The patch would be simpler
> without it.

First of all, currently it isn't possible to signal processes in an
ancestor pidns. Given the long thread about exit code visibility
semantics, I'm sure you see why bringing up this question is reasonable.

Some people (stupidly) bind-mount / into containers. There were several
CVEs in both LXC and runc where you could access the host filesystem
(including the host /proc). I'd prefer to not provide a mechanism for
such escalations to start sending signals to host processes, since I
don't see a strong reason why it should be allowed (and allowing it
would add more cracks to the isolation of pidns).

I think there is a huge difference between having read access to /proc
and being able to use /proc to signal processes which you ordinarily
would not be able to signal.

And another important point is that of semantics.

If we move forward with procfd_new() and the rest of the API we are
discussing, I'd argue we'd want to allow passing an nsfs fd to specify
what pidns we want the process to be created in (for procfd_new()). This
will obviously require a permission check to make sure we aren't
creating processes in a parent pidns -- and so for consistency all
procfd_* operations should have similar checks.

--=20
Aleksa Sarai
Senior Software Engineer (Containers)
SUSE Linux GmbH
<https://www.cyphar.com/>

--thafhy42vzv3dibt
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEb6Gz4/mhjNy+aiz1Snvnv3Dem58FAlvzLMgACgkQSnvnv3De
m59L2Q/+OJQ7gdLzIpx7d+MQpPjZPGxV0hXnzCPCHpNk0fvNX/88T4V619JUGzEc
yyeQSLPO6/lAg8PHe4AOVeWRqbVxzPUsamBxbugY24jm4tC2hWA4cEDqWfFtCZyx
Es19/kiTXrJIlnNIiB6fQ0xZXgTPzhT+XnR3/kyVtKaIFjcwW+9sA08s4mI/nn+w
0mWN+q/vr5EGsffsMnBj3w9HJNR/aUSvVso+B0fPpABL53Ez9VSHVinBjcRxgrZ0
S9shLMCZgdBXdgVOiZ1PCda/CoNCVWNFR7BRTiSK+ltoapWFz86KP+9HQr1DL4JX
pXpYnxAqnwFjQS83DaHt2jIlK1ExQOvPO1zpZ1HXPeZrypiRo2cH7WUnz2unLx9+
gSxxL8gN8FiVWqIi+kv6iZbnFitMaJbwZNLxd4lm/hxS0XzFXyi38TSX2YYaVx8A
qqlQ6Eic8cJ8QEC6DCcpsCAvN6NMWrRlXeAKuyCWLhGlb6ylplLwJto+ZKXpa0DI
6dm/Uy98Oi/J3kKACl1F1uiMPYcfKFMGJ7YSvfQpL96THp/3YNCiR9L73oulYcDC
TlELJKY+LmZDShft3QwlJ7iKVKXoMez2dsmptIItj105YW3oy+L1WRVDXdZs3nQJ
+fXNDc79x0U/5mtDhDvmCvpko4+VVEZaxTcCGw9vBv49zcsmY0A=
=BtVO
-----END PGP SIGNATURE-----

--thafhy42vzv3dibt--

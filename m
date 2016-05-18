From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v6 16/20] IB/fmr_pool: Convert the cleanup thread into
 kthread worker API
Date: Wed, 18 May 2016 11:36:33 -0400
Message-ID: <d62ae983-aa52-e60b-712f-e47708f2bfb7@redhat.com>
References: <1460646879-617-1-git-send-email-pmladek@suse.com>
 <1460646879-617-17-git-send-email-pmladek@suse.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="B4jlfRJk9sh51sJDPxaeTFG9r0QdnC0nw"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1460646879-617-17-git-send-email-pmladek-IBi9RG/b67k@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Petr Mladek <pmladek-IBi9RG/b67k@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>, Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--B4jlfRJk9sh51sJDPxaeTFG9r0QdnC0nw
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 04/14/2016 11:14 AM, Petr Mladek wrote:
> Kthreads are currently implemented as an infinite loop. Each
> has its own variant of checks for terminating, freezing,
> awakening. In many cases it is unclear to say in which state
> it is and sometimes it is done a wrong way.
>=20
> The plan is to convert kthreads into kthread_worker or workqueues
> API. It allows to split the functionality into separate operations.
> It helps to make a better structure. Also it defines a clean state
> where no locks are taken, IRQs blocked, the kthread might sleep
> or even be safely migrated.
>=20
> The kthread worker API is useful when we want to have a dedicated
> single thread for the work. It helps to make sure that it is
> available when needed. Also it allows a better control, e.g.
> define a scheduling priority.
>=20
> This patch converts the frm_pool kthread into the kthread worker
> API because I am not sure how busy the thread is. It is well
> possible that it does not need a dedicated kthread and workqueues
> would be perfectly fine. Well, the conversion between kthread
> worker API and workqueues is pretty trivial.
>=20
> The patch moves one iteration from the kthread into the work function.
> It preserves the check for a spurious queuing (wake up). Then it
> processes one request. Finally, it re-queues itself if more requests
> are pending.
>=20
> Otherwise, wake_up_process() is replaced by queuing the work.
>=20
> Important: The change is only compile tested. I did not find an easy
> way how to check it in a real life.

I had to do some digging myself to figure out how to move forward on
this patch.  The issue is that your conversion touches the fmr_pool code
as your target.  That code is slowly being phased out.  Right now, only
two drivers in the IB core support fmr: mthca and mlx4.  The generally
preferred method of mem management is fr instead of fmr.  The mlx4
driver support both fr and fmr, while the mthca driver is fmr only.  All
of the other drivers are fr only.  The only code that uses the fmr pools
are the upper layer iSER and SRP drivers.  So, if you have mthca
hardware, you can test fmr using either iSER or SRP clients.  If you
have mlx4 hardware, you can still test fmr by using the SRP client and
setting prefer_fr to false when you load the module.

Now that I know that, I can provide testing of this patch when the
overall patchset is ready to be submitted next.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--B4jlfRJk9sh51sJDPxaeTFG9r0QdnC0nw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJXPIwBAAoJELgmozMOVy/drgsP/jbdrRoWcMiq7FnAV/MGP7+C
Pf8VqrSoMgF6RrdIRofcrpZP+eODYdBleTqq14fFpnN3tMvCnLGyKr2fpFlpw95C
gKIt8TVLNWnGRkfOhgvtJ0L/VAraF4QFXvGHasKw8QGSuDCP2tXfM3O0OFeAnUNx
MAXj6B0QIfhMGZTgRbSfZ+HS8O8gYYC50vMwzXGyRqsafh5GqmtVGWH6e1UQ7FfT
zh+bt6WFJw6Y3fgZKQWnY9PuXdeMr1bXr5O2nf4JEhFfenP/D26CpkEwf+iAAQSi
0R84T3tFFR6WCqB/RjnGHhcF358dWoXNyV6SJcgGlJ9pYfRQ5nWRpi50iLiak7eK
QBRcBwlBl4eVFRuWB2GDAz6qovRWcZsCDjZCkNaJdH6/K7nd4n70moGEihoJ2GVd
6yheYxn4Vg7Kv9r29O25S0/3WBHLchjeX+y10uQkxvyGW+/jdywWISI7j9Mt9G9G
trs4OEyQsAb0x73ye548tkPtHm/jAEapcEwt+v6Ilb3lp2qCcd/2gm7SbIZIJlFe
g8FDUdO5qo7nbK0sQW6UNkYwXweXMprSNy6dNgf6L1K46+EW3nRj/L5XhnEWTLZq
3qzNudWCKD/xSS5LTUoEm23DUGeLBRQmH0Xdd4OxK67KDIwk8UrMJ344FCF1uxOa
uLneBbe4G4ZHE9ZxdySO
=T0xk
-----END PGP SIGNATURE-----

--B4jlfRJk9sh51sJDPxaeTFG9r0QdnC0nw--

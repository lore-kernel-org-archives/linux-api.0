From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [lxc-devel] CGroup Namespaces (v10)
Date: Mon, 15 Feb 2016 16:20:36 -0500
Message-ID: <20160215212036.GR3965@htj.duckdns.org>
References: <1454057651-23959-1-git-send-email-serge.hallyn@ubuntu.com>
 <CAMXgnP6eSQjsuPXdrbaHytujVSkizPd4cJJQwQcuSCLAgVcYJw@mail.gmail.com>
 <20160212160906.GG3741@mtj.duckdns.org>
 <20160212232221.GA31062@mail.hallyn.com>
 <20160215211705.GQ3965@htj.duckdns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160215211705.GQ3965-piEFEHQLUPpN0TnZuCh8vA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>
Cc: Alban Crequy <alban.crequy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, LXC development mailing-list <lxc-devel-cunTk1MwBs9qMoObBWhMNEqPaTDuhLve2LY78lusg7I@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Aditya Kali <adityakali-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Mon, Feb 15, 2016 at 04:17:05PM -0500, Tejun Heo wrote:
> I'm getting the following on top of the current for-4.6.  Can you
> please look into it?
>=20
> [kernel/cgroup.c:219:13: error: =E2=80=98cgroupns_operations=E2=80=99=
 undeclared here (not in a function)
>   .ns.ops  =3D &cgroupns_operations,
>                ^

Never mind.  That was me being stupid with trivial conflict
resolution.

Thanks.

--=20
tejun

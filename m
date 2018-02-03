From: "Serge E. Hallyn" <serge@hallyn.com>
Subject: Re: RFC(V3): Audit Kernel Container IDs
Date: Fri, 2 Feb 2018 19:57:21 -0600
Message-ID: <20180203015721.GB27295@mail.hallyn.com>
References: <20180109121620.wi7dq2423ugsraqv@madcap2.tricolour.ca>
 <CAHC9VhQ5ciUZDhrsb6S4YxwuzQEY-ra2RTDceWXOdjHEBoZ0BQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAHC9VhQ5ciUZDhrsb6S4YxwuzQEY-ra2RTDceWXOdjHEBoZ0BQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Paul Moore <paul@paul-moore.com>
Cc: Richard Guy Briggs <rgb@redhat.com>, cgroups@vger.kernel.org, Linux Containers <containers@lists.linux-foundation.org>, Linux API <linux-api@vger.kernel.org>, Linux Audit <linux-audit@redhat.com>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, Linux Kernel <linux-kernel@vger.kernel.org>, Linux Network Development <netdev@vger.kernel.org>, mszeredi@redhat.com, Andy Lutomirski <luto@kernel.org>, jlayton@redhat.com, Carlos O'Donell <carlos@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, David Howells <dhowells@redhat.com>, Simo Sorce <simo@redhat.com>, trondmy@primarydata.com, Eric Paris <eparis@parisplace.org>, "Serge E. Hallyn" <serge@hallyn.com>, "Eric W. Biederman" <ebiederm@xmission.com>
List-Id: linux-api@vger.kernel.org

On Fri, Feb 02, 2018 at 05:05:22PM -0500, Paul Moore wrote:
> On Tue, Jan 9, 2018 at 7:16 AM, Richard Guy Briggs <rgb@redhat.com> wrote:
> > Containers are a userspace concept.  The kernel knows nothing of them.
> >
> > The Linux audit system needs a way to be able to track the container
> > provenance of events and actions.  Audit needs the kernel's help to do
> > this.
> 
> Two small comments below, but I tend to think we are at a point where
> you can start cobbling together some prototype/RFC patches.  Surely

Agreed.

LGTM.

> there are going to be a few changes, and new comments, that come out
> once we see an initial implementation so let's see what those are.

thanks,
-serge

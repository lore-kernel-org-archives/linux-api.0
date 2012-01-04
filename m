From: Guillem Jover <guillem@hadrons.org>
Subject: Re: [PATCH] Use __unused0 instead of __unused for user visible
 struct member names
Date: Wed, 4 Jan 2012 09:14:14 +0100
Message-ID: <20120104081414.GA29745@gaara.hadrons.org>
References: <20120102024418.GA10483@gaara.hadrons.org>
 <20120102202243.GA31103@elie.hsd1.il.comcast.net>
 <20120103065659.GA32216@merkur.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20120103065659.GA32216@merkur.ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Jonathan Nieder <jrnieder@gmail.com>, linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org, linux-api@vger.kernel.org, Michal Marek <mmarek@suse.cz>
List-Id: linux-api@vger.kernel.org

On Tue, 2012-01-03 at 07:56:59 +0100, Sam Ravnborg wrote:
> On Mon, Jan 02, 2012 at 02:22:43PM -0600, Jonathan Nieder wrote:
> > Guillem Jover wrote:
> > > On BSD systems __unused has traditionally been defined to mean the
> > > equivalent of gcc's __attribute__((__unused__)), some parts of the
> > > Linux tree use that convention too (e.g. perf). The problem comes when
> > > defining such macro while trying to build unmodified source code with
> > > BSD origins on systems with Linux headers.
> > >
> > > Rename the user visible struct members from __unused to __unused0 to
> > > not cause compilation failures due to that macro, which should not be
> > > a problem as those members are supposed to be private anyway.
> 
> ^__ is reserved for libc internal stuff and there is no reason to
> name the unused/padding members "__unused".
> So one or a set of patches that rename them all to something more
> sensible would be fine.

On a quick glance, I've found other functionally similar struct
member names present on the tree:

  __unused __unusedN __reserved __reservedN __reserved_N __resN
  __pad __padN __flr_pad __ifi_pad __tcpm_padN __tcpct_padN

Do you mean you'd like to see patch(es) to rename all those? I'd not
mind providing them, although my immediate concern right now is just
regarding __unused.

There's also __buf in linux/sem.h and __data in linux/socket.h, but
I'd rather not thouch those, as I'd expect to be users for them?

thanks,
guillem

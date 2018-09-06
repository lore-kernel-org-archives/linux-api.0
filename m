From: Yann Droneaud <ydroneaud@opteya.com>
Subject: Re: [PATCH 05/11] UAPI: coda: Don't use internal kernel structs in
 UAPI
Date: Thu, 06 Sep 2018 13:52:29 +0200
Message-ID: <2e337313415a1ede1fb7a777902a0de7cb7c2602.camel@opteya.com>
References: <1c57005277ac723ebb670a1dc847a205f0529d53.camel@opteya.com>
         <153616286704.23468.584491117180383924.stgit@warthog.procyon.org.uk>
         <153616291029.23468.16421004714304578585.stgit@warthog.procyon.org.uk>
         <9916.1536218032@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <9916.1536218032@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Cc: linux-api@vger.kernel.org, linux-kbuild@vger.kernel.org, Jan Harkes <jaharkes@cs.cmu.edu>, coda@cs.cmu.edu, codalist@coda.cs.cmu.edu, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Hi,

Le jeudi 06 septembre 2018 à 08:13 +0100, David Howells a écrit :
> Yann Droneaud <ydroneaud@opteya.com> wrote:
> 
> > This structure should not have been exposed to userspace in the
> > first
> > place: it's unusable by userspace as it is. It was incorrect to
> > have it
> > outside of #ifdef __KERNEL__ before commit 607ca46e97a1b ... 
> > ...
> > All CODA_REQ_* defines internals to kernel side and not exchanged
> > with
> > userspace.
> > 
> > Please move them back to <linux/coda_psdev.h>
> 
> Is there any reason coda_psdev.h needs to be in include/linux/ rather
> than fs/coda/?
> 

It's a valid concern.

At first I thought the first lines (see below) could have been useful
for userspace:

  #define CODA_PSDEV_MAJOR 67
  #define MAX_CODADEVS  5    /* how many do we allow */


But the file was unsuable for a long long time so we can assume it's
usage by userspace is deprecated, then we could remove it from UAPI,
and moves its content back to include/linux.

As one could see include/linux/coda_psdev.h is not used outside of
fs/coda, moving the header here as you suggests seems to be the correct
solution.

Regards.

-- 
Yann Droneaud
OPTEYA

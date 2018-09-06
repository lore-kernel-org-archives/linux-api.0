From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 05/11] UAPI: coda: Don't use internal kernel structs in UAPI
Date: Thu, 06 Sep 2018 15:53:53 +0100
Message-ID: <25412.1536245633@warthog.procyon.org.uk>
References: <2e337313415a1ede1fb7a777902a0de7cb7c2602.camel@opteya.com> <1c57005277ac723ebb670a1dc847a205f0529d53.camel@opteya.com> <153616286704.23468.584491117180383924.stgit@warthog.procyon.org.uk> <153616291029.23468.16421004714304578585.stgit@warthog.procyon.org.uk> <9916.1536218032@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <2e337313415a1ede1fb7a777902a0de7cb7c2602.camel@opteya.com>
Content-ID: <25411.1536245633.1@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Yann Droneaud <ydroneaud@opteya.com>
Cc: dhowells@redhat.com, linux-api@vger.kernel.org, linux-kbuild@vger.kernel.org, Jan Harkes <jaharkes@cs.cmu.edu>, coda@cs.cmu.edu, codalist@coda.cs.cmu.edu, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Yann Droneaud <ydroneaud@opteya.com> wrote:

> At first I thought the first lines (see below) could have been useful
> for userspace:
> 
>   #define CODA_PSDEV_MAJOR 67
>   #define MAX_CODADEVS  5    /* how many do we allow */

Note that I was asking about include/linux/coda_psdev.h (the internal kernel
header), not include/uapi/linux/coda_psdev.h (the UAPI header).

David

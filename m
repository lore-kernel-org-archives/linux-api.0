From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 03/11] UAPI: virtio_net: Fix use of C++ keywords as structural members
Date: Thu, 06 Sep 2018 08:09:19 +0100
Message-ID: <9357.1536217759@warthog.procyon.org.uk>
References: <20180905125636-mutt-send-email-mst@kernel.org> <153616286704.23468.584491117180383924.stgit@warthog.procyon.org.uk> <153616289529.23468.7498785670556620808.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180905125636-mutt-send-email-mst@kernel.org>
Content-ID: <9356.1536217759.1@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: dhowells@redhat.com, linux-api@vger.kernel.org, linux-kbuild@vger.kernel.org, Jason Wang <jasowang@redhat.com>, virtualization@lists.linux-foundation.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Michael S. Tsirkin <mst@redhat.com> wrote:

> As long as you do not intend to use any classes, how about
> simply adding
> 
> -Dclass=_class
> 
> to your command line?

That kind of misses the point;-).  It's not reasonable to expect all userspace
C++ users to do this.

David

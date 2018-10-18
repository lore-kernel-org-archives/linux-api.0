From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 2/3] uapi: get rid of STATX_ALL
Date: Thu, 18 Oct 2018 16:16:46 +0100
Message-ID: <1240.1539875806@warthog.procyon.org.uk>
References: <20181018131125.6303-2-mszeredi@redhat.com> <20181018131125.6303-1-mszeredi@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181018131125.6303-2-mszeredi@redhat.com>
Content-ID: <1239.1539875806.1@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Miklos Szeredi <mszeredi@redhat.com>
Cc: dhowells@redhat.com, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Michael Kerrisk <mtk.manpages@gmail.com>, Andreas Dilger <adilger@dilger.ca>, Florian Weimer <fw@deneb.enyo.de>, Amir Goldstein <amir73il@gmail.com>
List-Id: linux-api@vger.kernel.org

Miklos Szeredi <mszeredi@redhat.com> wrote:

> Constants of the *_ALL type can be actively harmful due to the fact that
> developers will usually fail to consider the possible effects of future
> changes to the definition.
> 
> Remove STATX_ALL from the uapi, while no damage has been done yet.

You don't know that someone's not using it.  It's been there a year and a
half, long enough.  So, regretfully, I don't think we can remove it at this
point.

David

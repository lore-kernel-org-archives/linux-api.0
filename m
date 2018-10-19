From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH v2 2/5] uapi: deprecate STATX_ALL
Date: Fri, 19 Oct 2018 19:30:15 +0200
Message-ID: <CAJfpegut_rcnssaaN2duCJruJOAJ+tzDsA0uUSEiNwS-QddArQ@mail.gmail.com>
References: <20181019122049.27121-1-mszeredi@redhat.com> <20181019122049.27121-2-mszeredi@redhat.com>
 <16382.1539963322@warthog.procyon.org.uk> <CAJfpegviiy=9fru3zButbqLnhshH85srH3qyZO2zf-_RPqSs=g@mail.gmail.com>
 <17323.1539964061@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <17323.1539964061@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Cc: Miklos Szeredi <mszeredi@redhat.com>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, Linux API <linux-api@vger.kernel.org>, Michael Kerrisk <mtk.manpages@gmail.com>, Andreas Dilger <adilger@dilger.ca>, Florian Weimer <fw@deneb.enyo.de>, Amir Goldstein <amir73il@gmail.com>
List-Id: linux-api@vger.kernel.org

On Fri, Oct 19, 2018 at 5:47 PM, David Howells <dhowells@redhat.com> wrote:
> Miklos Szeredi <miklos@szeredi.hu> wrote:
>
>> What is misleading about this?
>
> The manpage says:
>
>            STATX_ALL           [All currently available fields]

Ah, the manpage needs to be fixed, obviously.

>
>> If you feel confused by this comment, then maybe I should just drop that part.
>
> I think that would be better.  Don't try to give it a definition.

Okay.

Thanks,
Miklos

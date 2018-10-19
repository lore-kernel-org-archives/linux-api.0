From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH v2 2/5] uapi: deprecate STATX_ALL
Date: Fri, 19 Oct 2018 16:47:41 +0100
Message-ID: <17323.1539964061@warthog.procyon.org.uk>
References: <CAJfpegviiy=9fru3zButbqLnhshH85srH3qyZO2zf-_RPqSs=g@mail.gmail.com> <20181019122049.27121-1-mszeredi@redhat.com> <20181019122049.27121-2-mszeredi@redhat.com> <16382.1539963322@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAJfpegviiy=9fru3zButbqLnhshH85srH3qyZO2zf-_RPqSs=g@mail.gmail.com>
Content-ID: <17322.1539964061.1@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: dhowells@redhat.com, Miklos Szeredi <mszeredi@redhat.com>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, Linux API <linux-api@vger.kernel.org>, Michael Kerrisk <mtk.manpages@gmail.com>, Andreas Dilger <adilger@dilger.ca>, Florian Weimer <fw@deneb.enyo.de>, Amir Goldstein <amir73il@gmail.com>
List-Id: linux-api@vger.kernel.org

Miklos Szeredi <miklos@szeredi.hu> wrote:

> What is misleading about this?

The manpage says:

           STATX_ALL           [All currently available fields]

> If you feel confused by this comment, then maybe I should just drop that part.

I think that would be better.  Don't try to give it a definition.

David

From: David Howells <dhowells@redhat.com>
Subject: Re: [RFC PATCH 00/27] Containers and using authenticated filesystems
Date: Tue, 19 Feb 2019 23:42:09 +0000
Message-ID: <22055.1550619729@warthog.procyon.org.uk>
References: <8736ojybw7.fsf@xmission.com> <155024683432.21651.14153938339749694146.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <8736ojybw7.fsf@xmission.com>
Content-ID: <22054.1550619729.1@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: dhowells@redhat.com, keyrings@vger.kernel.org, trond.myklebust@hammerspace.com, sfrench@samba.org, linux-security-module@vger.kernel.org, linux-nfs@vger.kernel.org, linux-cifs@vger.kernel.org, linux-fsdevel@vger.kernel.org, rgb@redhat.com, linux-kernel@vger.kernel.org, Linux Containers <containers@lists.linux-foundation.org>, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Eric W. Biederman <ebiederm@xmission.com> wrote:

> So you missed the main mailing lists for discussion of this kind of
> thing

Yeah, sorry about that.  I was primarily aiming it at Trond and Steve as I'd
like to consider how to go about interpolating request_key() into NFS and CIFS
so that they can make use of the key-related facilities that this makes
available with AFS.  And I was in a bit tight for time to mail it out before
having to go out.  I know, excuses... ;-)

> and the maintainer.

That would be me.  I maintain keyrings.

No one is listed in MAINTAINERS as owning namespaces.  If you feel that should
be you, please add a record.

> Looking at your description you are introducing a container id.

Yes.  For audit logging, which was why I cc'd Richard.

> You don't descibe which namespace your contianer id lives in.

It doesn't.  Not everything has to have a namespace.  As you yourself pointed
out, it should be globally unique, in which case the world is the namespace,
maybe even the universe;-).

> Without the container id living in a container this breaks
> nested containers and process migration aka CRIU.

As long as IDs are globally unique, why should break container migration?
Having a kernel container object might even make CRIU easier.

And what does "Without the container id living in a container" mean anyway?  I
have IDs attached to containers.  A container can see the IDs of its child
containers.  There should be no problem with nesting.

David

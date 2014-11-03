From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH 1/3] fs: add O_BENEATH flag to openat(2)
Date: Mon, 3 Nov 2014 15:20:36 +0000
Message-ID: <20141103152036.GA7996@ZenIV.linux.org.uk>
References: <1415015305-15494-1-git-send-email-drysdale@google.com>
 <1415015305-15494-2-git-send-email-drysdale@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-security-module-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1415015305-15494-2-git-send-email-drysdale@google.com>
Sender: linux-security-module-owner@vger.kernel.org
To: David Drysdale <drysdale@google.com>
Cc: linux-kernel@vger.kernel.org, Kees Cook <keescook@chromium.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Meredydd Luff <meredydd@senatehouse.org>, Will Drewry <wad@chromium.org>, Jorge Lucangeli Obes <jorgelo@google.com>, Ricky Zhou <rickyz@google.com>, Lee Campbell <leecam@google.com>, Julien Tinnes <jln@google.com>, Mike Depinet <mdepinet@google.com>, James Morris <james.l.morris@oracle.com>, Andy Lutomirski <luto@amacapital.net>, Paolo Bonzini <pbonzini@redhat.com>, Paul Moore <paul@paul-moore.com>, Christoph Hellwig <hch@infradead.org>, "Eric W. Biederman" <ebiederm@xmission.com>, linux-api@vger.kernel.org, linux-security-module@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Mon, Nov 03, 2014 at 11:48:23AM +0000, David Drysdale wrote:
> Add a new O_BENEATH flag for openat(2) which restricts the
> provided path, rejecting (with -EACCES) paths that are not beneath
> the provided dfd.  In particular, reject:
>  - paths that contain .. components
>  - paths that begin with /
>  - symlinks that have paths as above.

Yecch...  The degree of usefulness aside (and I'm not convinced that it
is non-zero), WTF pass one bit out of nameidata->flags in a separate argument?
Through the mutual recursion, no less...  And then you are not even attempting
to detect symlinks that are not followed by interpretation of _any_ pathname.

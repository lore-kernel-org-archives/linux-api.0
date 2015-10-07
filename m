From: James Morris <jmorris@namei.org>
Subject: Re: [PATCH v9 00/43] Richacls
Date: Wed, 7 Oct 2015 18:33:09 +1100 (AEDT)
Message-ID: <alpine.LRH.2.20.1510071832320.20498@namei.org>
References: <1444073830-21854-1-git-send-email-agruenba@redhat.com> <20151006090746.GA27791@xo-6d-61-c0.localdomain> <CAHc6FU79km84DAg+-EHkwyBf3Wq-e5AhBYQ1eXdS8mDpmPR0ow@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAHc6FU79km84DAg+-EHkwyBf3Wq-e5AhBYQ1eXdS8mDpmPR0ow@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andreas Gruenbacher <agruenba@redhat.com>
Cc: Pavel Machek <pavel@ucw.cz>, Alexander Viro <viro@zeniv.linux.org.uk>, Theodore Ts'o <tytso@mit.edu>, Andreas Dilger <adilger.kernel@dilger.ca>, "J. Bruce Fields" <bfields@fieldses.org>, Jeff Layton <jlayton@poochiereds.net>, Trond Myklebust <trond.myklebust@primarydata.com>, Anna Schumaker <anna.schumaker@netapp.com>, linux-ext4@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-nfs@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Tue, 6 Oct 2015, Andreas Gruenbacher wrote:

> On Tue, Oct 6, 2015 at 11:07 AM, Pavel Machek <pavel@ucw.cz> wrote:
> > Should there be file in Documentation/ explaining how this works?
> 
> There are plenty of comments in the code and in the patch descriptions
> that describe how the code works. The user-space package has manual
> pages that describe how to use richacls; this information would not be
> accessible to users when put in Documentation/. Also, some background
> information is available on http://www.bestbits.at/richacl/.

Are many distros planning on enabling this?  I gather RH is...


-- 
James Morris
<jmorris@namei.org>

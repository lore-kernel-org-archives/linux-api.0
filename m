From: Jann Horn <jannh@google.com>
Subject: Re: [PATCH] ioctl_getfsmap.2: document the GETFSMAP ioctl
Date: Mon, 8 May 2017 20:47:56 +0200
Message-ID: <CAG48ez3e+2VuvjtEfJuMujEo6PWBO3z8oM-otN2juq96jKdjCw@mail.gmail.com>
References: <20170507155855.GD5970@birch.djwong.org> <CAG48ez1AWewJRg8gySgihn0y15jRhC6C+5DNwGsDpAhtokB=Lw@mail.gmail.com>
 <20170508184112.GJ5973@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-ext4-owner@vger.kernel.org>
In-Reply-To: <20170508184112.GJ5973@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Michael Kerrisk-manpages <mtk.manpages@gmail.com>, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, Linux API <linux-api@vger.kernel.org>, linux-man@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Mon, May 8, 2017 at 8:41 PM, Darrick J. Wong <darrick.wong@oracle.com> wrote:
> On Mon, May 08, 2017 at 12:17:53AM +0200, Jann Horn wrote:
>> On Sun, May 7, 2017 at 5:58 PM, Darrick J. Wong <darrick.wong@oracle.com> wrote:
>> > Document the new GETFSMAP ioctl that returns the physical layout of a
>> > (disk-based) filesystem.
[...]
>> Also: From a quick glance at the XFS implementation, I don't see any
>> privilege checks. Am I missing something, or does this API permit an
>> unprivileged user to determine the number of physical blocks allocated
>> for any inode, even for inodes the user can't ordinarily see in any
>> way?
>
> Correct.

What's your reasoning for why this doesn't create any new potential
security issues? For example, as far as I can tell, this would permit
an unprivileged user to determine with high probability whether a set
of large files with known sizes is stored anywhere in the filesystem, even
across containers or so.

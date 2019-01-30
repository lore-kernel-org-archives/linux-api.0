From: Karel Zak <kzak@redhat.com>
Subject: Re: [RFD] A mount api that notices previous mounts
Date: Wed, 30 Jan 2019 19:00:51 +0100
Message-ID: <20190130180051.caonbh2t7wtsdqo5@ws.net.home>
References: <20190130120654.q5zqcexquca7u337@ws.net.home>
 <87va2716mh.fsf@xmission.com>
 <9871.1548853314@warthog.procyon.org.uk>
 <87h8dqs1xw.fsf@xmission.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <87h8dqs1xw.fsf@xmission.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: David Howells <dhowells@redhat.com>, linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, Al Viro <viro@ZenIV.linux.org.uk>, Miklos Szeredi <miklos@szeredi.hu>, Linus Torvalds <torvalds@linux-foundation.org>, util-linux@vger.kernel.org, Andy Lutomirski <luto@amacapital.net>
List-Id: linux-api@vger.kernel.org

On Wed, Jan 30, 2019 at 07:35:39AM -0600, Eric W. Biederman wrote:
> I suspect that as long as userspace supports /etc/fstab and we in turn
> support /proc/mounts there is going to be a lot of pressure to keep
> the majority of options so they  can be encoded in a string separated by
> commas.

Well, we're doing many crazy things in userspace ;-) For example we do
not distinguish between VFS flags (MS_*), FS specific mount options
and userspace mount options (loop=) in our config files. 

You already need to parse fstab/command line before you can use the 
strings for mount(2) syscall. It's already not straightforward, see
all the code in libmount...

/proc/mounts is only for backward compatibility, /proc/self/mountinfo
is better way, because it allows to see VFS and FS, etc.

IMHO it would be better to not care about way how we use mount options 
strings now (in userspace) when you think about the new API design.

    Karel

-- 
 Karel Zak  <kzak@redhat.com>
 http://karelzak.blogspot.com

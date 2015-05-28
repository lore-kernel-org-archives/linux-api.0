From: Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>
Subject: Re: [CFT][PATCH 00/10] Making new mounts of proc and sysfs as safe
 as bind mounts (take 2)
Date: Thu, 28 May 2015 21:36:18 +0200
Message-ID: <55676E32.3050006@nod.at>
References: <87pp63jcca.fsf@x220.int.ebiederm.org> <87siaxuvik.fsf@x220.int.ebiederm.org> <87wq004im1.fsf@x220.int.ebiederm.org> <CALCETrUhXBR5WQ6gXr9KzGc4=7tph7kzopY29Hug4g+FhOzEKg@mail.gmail.com> <20150528140839.GD28842@ubuntumail>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150528140839.GD28842@ubuntumail>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Serge Hallyn <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Cc: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Seth Forshee <seth.forshee-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Kenton Varda <kenton-AuYgBwuPrUQTaNkGU808tA@public.gmane.org>, Michael Kerrisk-manpages <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Linux FS Devel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Am 28.05.2015 um 16:08 schrieb Serge Hallyn:
> Quoting Andy Lutomirski (luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org):
>> On Fri, May 22, 2015 at 10:39 AM, Eric W. Biederman
>> <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org> wrote:
>>> I had hoped to get some Tested-By's on that patch series.
>>
>> Sorry, I've been totally swamped.
>>
>> I suspect that Sandstorm is okay, but I haven't had a chance to test
>> it for real.  Sandstorm makes only limited use of proc and sysfs in
>> containers, but I'll see if I can test it for real this weekend.
> 
> Testing this with unprivileged containers, I get
> 
> lxc-start: conf.c: lxc_mount_auto_mounts: 808 Operation not permitted - error mounting sysfs on /usr/lib/x86_64-linux-gnu/lxc/sys/devices/virtual/net flags 0
>

FWIW, it breaks also libvirt-lxc:
Error: internal error: guest failed to start: Failed to re-mount /proc/sys on /proc/sys flags=1021: Operation not permitted

Thanks,
//richard

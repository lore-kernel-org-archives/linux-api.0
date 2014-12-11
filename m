From: Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>
Subject: Re: [CFT] Can I get some Tested-By's on this series?
Date: Thu, 11 Dec 2014 20:27:33 +0100
Message-ID: <5489F025.9010907@nod.at>
References: <CALCETrXWx2-ZejEHmOi7aSoF-qJMRGR5yseeMhuurZwJRrQbUg@mail.gmail.com>	<87h9x5re41.fsf_-_@x220.int.ebiederm.org>	<87mw6xpzb0.fsf_-_@x220.int.ebiederm.org>	<CALCETrU-o5mPr1jCaLXDuuF6J2N470zAtx=8Fa-SjF=ZpdE8mQ@mail.gmail.com>	<87ppbtn4mv.fsf@x220.int.ebiederm.org>	<CALCETrXSScp77BUJR5NSTh5-RnEZ9rqELSGJBeEzgdQ-OtohuQ@mail.gmail.com>	<87a92xn2io.fsf@x220.int.ebiederm.org>	<87r3w8liw4.fsf@x220.int.ebiederm.org>	<87iohklfvj.fsf_-_@x220.int.ebiederm.org>	<87mw6vh31e.fsf_-_@x220.int.ebiederm.org>	<20141210224822.GG20012@ubuntumail>
	<5488CE4D.1000606@nod.at> <87r3w7f5yc.fsf@x220.int.ebiederm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <87r3w7f5yc.fsf-JOvCrm2gF+uungPnsOpG7nhyD016LWXt@public.gmane.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/containers/>
List-Post: <mailto:containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
Cc: linux-man <linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, Serge Hallyn <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, stable <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Kenton Varda <kenton-AuYgBwuPrUQTaNkGU808tA@public.gmane.org>, LSM <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Michael Kerrisk-manpages <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Casey Schaufler <casey-iSGtlc1asvQWG2LlvL+J4A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Am 11.12.2014 um 00:19 schrieb Eric W. Biederman:
> Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org> writes:
> 
>> Am 10.12.2014 um 23:48 schrieb Serge Hallyn:
>>> Quoting Eric W. Biederman (ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org):
>>>>
>>>> Will people please test these patches with their container project?
>>>>
>>>> These changes break container userspace (hopefully in a minimal way) if
>>>> I could have that confirmed by testing I would really appreciate it.  I
>>>> really don't want to send out a bug fix that accidentally breaks
>>>> userspace again.
>>>>
>>>> The only issue sort of under discussion is if there is a better name for
>>>> /proc/<pid>/setgroups, and the name of the file will not affect the
>>>> functionality of the patchset.
>>>>
>>>> With the code reviewed and written in simple obviously correct, easily
>>>> reviewable ways I am hoping/planning to send this to Linus ASAP.
>>>>
>>>> Eric
>>>
>>> Is there a git tree we can clone?
>>
>> I was about to ask that too.
>> Hopefully I can tomorrow find some time for testing.
> 
> git pull git.kernel.org:/pub/scm/linux/kernel/git/ebiederm/user-namespace.git for-testing
> 
> That holds my entire queue of fixes against 3.18-rc6

So far nothing broke on my libvirt-lxc test bed. :-)
Tested with openSUSE 13.2 and libvirt 1.2.9.

Tested-by: Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>

Thanks,
//richard

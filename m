From: =?UTF-8?B?TWFoZXNoIEJhbmRld2FyICjgpK7gpLngpYfgpLYg4KSs4KSC4KSh4KWH4KS14KS+4KSwKQ==?= <maheshb@google.com>
Subject: Re: Re: [PATCH resend 2/2] userns: control
 capabilities of some user namespaces
Date: Thu, 9 Nov 2017 16:13:06 +0900
Message-ID: <CAF2d9ji2G+sW=Ra=xMAB+2jBhWO60JYgr0rGjLHfAW5nj17O-Q@mail.gmail.com>
References: <20171106150302.GA26634@mail.hallyn.com> <1510003994.736.0.camel@gmail.com>
 <20171106221418.GA32543@mail.hallyn.com> <CAFUG7CcEy9a=RxBQZJR-C_2VuhZXrzJ_QxJnrSxdM=ox36DsXQ@mail.gmail.com>
 <20171106233913.GA1518@mail.hallyn.com> <CAFUG7CcW077LHcQEqk7qy7iVvmi-3J8psD1Kwj45XvHThiZC6w@mail.gmail.com>
 <20171107032802.GA6669@mail.hallyn.com> <CAF2d9jiwu3Ss7Dtem8qSptKgMc0Mc_o8MAAJkWM5CwJaFsbrcg@mail.gmail.com>
 <20171108190223.vdkyepcaegmub6le@gmail.com> <CAF2d9jjed4Q7QvCD9Kpaa7L-Ngg3XFbJvt0jNVUUwt=52wDjjw@mail.gmail.com>
 <20171109032134.GA15666@mail.hallyn.com>
Mime-Version: 1.0
Content-Type: multipart/alternative; boundary="f403045f6eb65f5017055d878a83"
Return-path: <kernel-hardening-return-10472-glkh-kernel-hardening=m.gmane.org@lists.openwall.com>
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
In-Reply-To: <20171109032134.GA15666@mail.hallyn.com>
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: Christian Brauner <christian.brauner@canonical.com>, Boris Lukashev <blukashev@sempervictus.com>, Daniel Micay <danielmicay@gmail.com>, Mahesh Bandewar <mahesh@bandewar.net>, LKML <linux-kernel@vger.kernel.org>, Netdev <netdev@vger.kernel.org>, Kernel-hardening <kernel-hardening@lists.openwall.com>, Linux API <linux-api@vger.kernel.org>, Kees Cook <keescook@chromium.org>, "Eric W . Biederman" <ebiederm@xmission.com>, Eric Dumazet <edumazet@google.com>, David Miller <davem@davemloft.net>
List-Id: linux-api@vger.kernel.org

--f403045f6eb65f5017055d878a83
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 9, 2017 at 12:21 PM, Serge E. Hallyn <serge@hallyn.com> wrote:
> On Thu, Nov 09, 2017 at 09:55:41AM +0900, Mahesh Bandewar (=E0=A4=AE=E0=
=A4=B9=E0=A5=87=E0=A4=B6 =E0=A4=AC=E0=A4=82=E0=A4=A1=E0=A5=87=E0=A4=B5=E0=
=A4=BE=E0=A4=B0)
wrote:
>> On Thu, Nov 9, 2017 at 4:02 AM, Christian Brauner
>> <christian.brauner@canonical.com> wrote:
>> > On Wed, Nov 08, 2017 at 03:09:59AM -0800, Mahesh Bandewar (=E0=A4=AE=
=E0=A4=B9=E0=A5=87=E0=A4=B6
=E0=A4=AC=E0=A4=82=E0=A4=A1=E0=A5=87=E0=A4=B5=E0=A4=BE=E0=A4=B0) wrote:
>> >> Sorry folks I was traveling and seems like lot happened on this
thread. :p
>> >>
>> >> I will try to response few of these comments selectively -
>> >>
>> >> > The thing that makes me hesitate with this set is that it is a
>> >> > permanent new feature to address what (I hope) is a temporary
>> >> > problem.
>> >> I agree this is permanent new feature but it's not solving a temporar=
y
>> >> problem. It's impossible to assess what and when new vulnerability
>> >> that could show up. I think Daniel summed it up appropriately in his
>> >> response
>> >>
>> >> > Seems like there are two naive ways to do it, the first being to
just
>> >> > look at all code under ns_capable() plus code called from there.  I=
t
>> >> > seems like looking at the result of that could be fruitful.
>> >> This is really hard. The main issue that there were features designed
>> >> and developed before user-ns days with an assumption that unprivilege=
d
>> >> users will never get certain capabilities which only root user gets.
>> >> Now that is not true anymore with user-ns creation with mapping root
>> >> for any process. Also at the same time blocking user-ns creation for
>> >> eveyone is a big-hammer which is not needed too. So it's not that eas=
y
>> >> to just perform a code-walk-though and correct those decisions now.
>> >>
>> >> > It seems to me that the existing control in
>> >> > /proc/sys/kernel/unprivileged_userns_clone might be the better duct
tape
>> >> > in that case.
>> >> This solution is essentially blocking unprivileged users from using
>> >> the user-namespaces entirely. This is not really a solution that can
>> >> work. The solution that this patch-set adds allows unprivileged users
>> >> to create user-namespaces. Actually the proposed solution is more
>> >> fine-grained approach than the unprivileged_userns_clone solution
>> >> since you can selectively block capabilities rather than completely
>> >> blocking the functionality.
>> >
>> > I've been talking to St=C3=A9phane today about this and we should also=
 keep
in mind
>> > that we have:
>> >
>> > chb@conventiont|~
>> >> ls -al /proc/sys/user/
>> > total 0
>> > dr-xr-xr-x 1 root root 0 Nov  6 23:32 .
>> > dr-xr-xr-x 1 root root 0 Nov  2 22:13 ..
>> > -rw-r--r-- 1 root root 0 Nov  8 19:48 max_cgroup_namespaces
>> > -rw-r--r-- 1 root root 0 Nov  8 19:48 max_inotify_instances
>> > -rw-r--r-- 1 root root 0 Nov  8 19:48 max_inotify_watches
>> > -rw-r--r-- 1 root root 0 Nov  8 19:48 max_ipc_namespaces
>> > -rw-r--r-- 1 root root 0 Nov  8 19:48 max_mnt_namespaces
>> > -rw-r--r-- 1 root root 0 Nov  8 19:48 max_net_namespaces
>> > -rw-r--r-- 1 root root 0 Nov  8 19:48 max_pid_namespaces
>> > -rw-r--r-- 1 root root 0 Nov  8 19:48 max_user_namespaces
>> > -rw-r--r-- 1 root root 0 Nov  8 19:48 max_uts_namespaces
>> >
>> > These files allow you to limit the number of namespaces that can be
created
>> > *per namespace* type. So let's say your system runs a bunch of user
namespaces
>> > you can do:
>> >
>> > chb@conventiont|~
>> >> echo 0 > /proc/sys/user/max_user_namespaces
>> >
>> > So that the next time you try to create a user namespaces you'd see:
>> >
>> > chb@conventiont|~
>> >> unshare -U
>> > unshare: unshare failed: No space left on device
>> >
>> > So there's not even a need to upstream a new sysctl since we have ways
of
>> > blocking this.
>> >
>> I'm not sure how it's solving the problem that my patch-set is
addressing?
>> I agree though that the need for unprivileged_userns_clone sysctl goes
>> away as this is equivalent to setting that sysctl to 0 as you have
>> described above.
>
> oh right that was the reasoning iirc for not needing the other sysctl.
>
>> However as I mentioned earlier, blocking processes from creating
>> user-namespaces is not the solution. Processes should be able to
>> create namespaces as they are designed but at the same time we need to
>> have controls to 'contain' them if a need arise. Setting max_no to 0
>> is not the solution that I'm looking for since it doesn't solve the
>> problem.
>
> well yesterday we were told that was explicitly not the goal, but that wa=
s
> not by you ... i just mention it to explain why we seem to be walking in
> circles a bit.
>
> anyway the bounding set doesn't actually make sense so forget that.   the
> question then is just whether it makes sense to allow things to continue
> at all in this situation.  would you mind indulging me by giving one or
two
> concrete examples in the previous known cves of what capabilities you
would
> have dropped tto allow the rest to continue to be safely used?
>
Of course. Let's take an example of the CVE that I have mentioned in my
cover-letter - CVE-2017-7308
<https://cve.mitre.org/cgi-bin/cvename.cgi?name=3DCVE-2017-7308>. It's well
documented and even has a exploit c-program
<https://github.com/xairy/kernel-exploits/tree/master/CVE-2017-7308> that
can demonstrate how it can be used against non-patched kernel. There is
very nice blog post
<https://googleprojectzero.blogspot.kr/2017/05/exploiting-linux-kernel-via-=
packet.html>
about this vulnerability by Andrey Konovalov.

This is about the AF_PACKET socket interface that is protected behind
NET_RAW capability. This capability is not available to unprivileged user.
However, any unprivileged user can get NET_RAW capability (as demonstrated
in the cover-letter code that I have attached in this patch series) so this
NET_RAW capability is available to any unprivileged user on the host if the
kernel has user-namespaces available.

With this patch-set applied, all that is needed is to flip a bit with the
sysctl (kernel.controlled_userns_caps_whitelist) as demonstrated below -

root@lphh6:~# uname -a
Linux lphh6 4.14.0-smp-DEV #97 SMP @1510203579 x86_64 GNU/Linux
root@lphh6:~# sysctl -q kernel.controlled_userns_caps_whitelist
kernel.controlled_userns_caps_whitelist =3D 1f,ffffffff

Now when I run the program (demo from the cover-letter) as a normal
unprivileged user I can't create a RAW socket in init-ns but I can in the
child-ns.

dumbo@lphh6:~$ /tmp/acquire_raw
Attempting to open RAW socket before unshare()...
socket() SOCK_RAW failed: : Operation not permitted
Attempting to open RAW socket after unshare()...
Successfully opened RAW-Sock after unshare().
dumbo@lphh6:~$

Now as a root user. Take off CAP_NET_RAW

root@lphh6:~# sysctl -w kernel.controlled_userns_caps_whitelist=3D1f,ffffdf=
ff
kernel.controlled_userns_caps_whitelist =3D 1f,ffffdfff
root@lphh6:~#

Now run the same program as an unprivileged user -

dumbo@lphh6:~$ /tmp/acquire_raw
Attempting to open RAW socket before unshare()...
socket() SOCK_RAW failed: : Operation not permitted
Attempting to open RAW socket after unshare()...
socket() SOCK_RAW failed: : Operation not permitted
dumbo@lphh6:~$

Notice that it has failed to create a raw socket in init and in child
namespace. It's not blocking creation of user-namespaces but allowing admin
turn individual capability bits on and off.

This is very simplistic example of just demonstrating how capability bits
turn-on/off works. So let's assume a sandboxed environment where we don't
know what a binary that we are about run in an environment which is
identified as susceptible. By turning off the NET_RAW bit, the admin gets
an assurance that system is safe and if binary fails because it's not
getting this capability then that bad but a sad consequence (without
compromising the host integrity) but if it doesn't use the NET_RAW
capability but any other combination of remaining 36 capabilities, it would
get whatever is necessary. This means we can safely allow processes to
create user-namespaces by taking off certain capabilities in question for
temporary/extended period until proper fix is applied without compromising
the system integrity. The impact will vary based on which capability is
taken off and admin would / should be ware of for the environment that
he/she is dealing with.

thanks,
--mahesh..

> thanks,
> serge

--f403045f6eb65f5017055d878a83
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><br><br>On Thu, Nov 9, 2017 at 12:21 PM, Serge E. Hallyn &=
lt;<a href=3D"mailto:serge@hallyn.com" target=3D"_blank">serge@hallyn.com</=
a>&gt; wrote:<br>&gt; On Thu, Nov 09, 2017 at 09:55:41AM +0900, Mahesh Band=
ewar (=E0=A4=AE=E0=A4=B9=E0=A5=87=E0=A4=B6 =E0=A4=AC=E0=A4=82=E0=A4=A1=E0=
=A5=87=E0=A4=B5=E0=A4=BE=E0=A4=B0) wrote:<br>&gt;&gt; On Thu, Nov 9, 2017 a=
t 4:02 AM, Christian Brauner<br>&gt;&gt; &lt;<a href=3D"mailto:christian.br=
auner@canonical.com" target=3D"_blank">christian.brauner@canonical.c<wbr>om=
</a>&gt; wrote:<br>&gt;&gt; &gt; On Wed, Nov 08, 2017 at 03:09:59AM -0800, =
Mahesh Bandewar (=E0=A4=AE=E0=A4=B9=E0=A5=87=E0=A4=B6 =E0=A4=AC=E0=A4=82=E0=
=A4=A1=E0=A5=87=E0=A4=B5=E0=A4=BE=E0=A4=B0) wrote:<br>&gt;&gt; &gt;&gt; Sor=
ry folks I was traveling and seems like lot happened on this thread. :p<br>=
&gt;&gt; &gt;&gt;<br>&gt;&gt; &gt;&gt; I will try to response few of these =
comments selectively -<br>&gt;&gt; &gt;&gt;<br>&gt;&gt; &gt;&gt; &gt; The t=
hing that makes me hesitate with this set is that it is a<br>&gt;&gt; &gt;&=
gt; &gt; permanent new feature to address what (I hope) is a temporary<br>&=
gt;&gt; &gt;&gt; &gt; problem.<br>&gt;&gt; &gt;&gt; I agree this is permane=
nt new feature but it&#39;s not solving a temporary<br>&gt;&gt; &gt;&gt; pr=
oblem. It&#39;s impossible to assess what and when new vulnerability<br>&gt=
;&gt; &gt;&gt; that could show up. I think Daniel summed it up appropriatel=
y in his<br>&gt;&gt; &gt;&gt; response<br>&gt;&gt; &gt;&gt;<br>&gt;&gt; &gt=
;&gt; &gt; Seems like there are two naive ways to do it, the first being to=
 just<br>&gt;&gt; &gt;&gt; &gt; look at all code under ns_capable() plus co=
de called from there.=C2=A0 It<br>&gt;&gt; &gt;&gt; &gt; seems like looking=
 at the result of that could be fruitful.<br>&gt;&gt; &gt;&gt; This is real=
ly hard. The main issue that there were features designed<br>&gt;&gt; &gt;&=
gt; and developed before user-ns days with an assumption that unprivileged<=
br>&gt;&gt; &gt;&gt; users will never get certain capabilities which only r=
oot user gets.<br>&gt;&gt; &gt;&gt; Now that is not true anymore with user-=
ns creation with mapping root<br>&gt;&gt; &gt;&gt; for any process. Also at=
 the same time blocking user-ns creation for<br>&gt;&gt; &gt;&gt; eveyone i=
s a big-hammer which is not needed too. So it&#39;s not that easy<br>&gt;&g=
t; &gt;&gt; to just perform a code-walk-though and correct those decisions =
now.<br>&gt;&gt; &gt;&gt;<br>&gt;&gt; &gt;&gt; &gt; It seems to me that the=
 existing control in<br>&gt;&gt; &gt;&gt; &gt; /proc/sys/kernel/unprivilege=
d_<wbr>userns_clone might be the better duct tape<br>&gt;&gt; &gt;&gt; &gt;=
 in that case.<br>&gt;&gt; &gt;&gt; This solution is essentially blocking u=
nprivileged users from using<br>&gt;&gt; &gt;&gt; the user-namespaces entir=
ely. This is not really a solution that can<br>&gt;&gt; &gt;&gt; work. The =
solution that this patch-set adds allows unprivileged users<br>&gt;&gt; &gt=
;&gt; to create user-namespaces. Actually the proposed solution is more<br>=
&gt;&gt; &gt;&gt; fine-grained approach than the unprivileged_userns_clone =
solution<br>&gt;&gt; &gt;&gt; since you can selectively block capabilities =
rather than completely<br>&gt;&gt; &gt;&gt; blocking the functionality.<br>=
&gt;&gt; &gt;<br>&gt;&gt; &gt; I&#39;ve been talking to St=C3=A9phane today=
 about this and we should also keep in mind<br>&gt;&gt; &gt; that we have:<=
br>&gt;&gt; &gt;<br>&gt;&gt; &gt; chb@conventiont|~<br>&gt;&gt; &gt;&gt; ls=
 -al /proc/sys/user/<br>&gt;&gt; &gt; total 0<br>&gt;&gt; &gt; dr-xr-xr-x 1=
 root root 0 Nov =C2=A06 23:32 .<br>&gt;&gt; &gt; dr-xr-xr-x 1 root root 0 =
Nov =C2=A02 22:13 ..<br>&gt;&gt; &gt; -rw-r--r-- 1 root root 0 Nov =C2=A08 =
19:48 max_cgroup_namespaces<br>&gt;&gt; &gt; -rw-r--r-- 1 root root 0 Nov =
=C2=A08 19:48 max_inotify_instances<br>&gt;&gt; &gt; -rw-r--r-- 1 root root=
 0 Nov =C2=A08 19:48 max_inotify_watches<br>&gt;&gt; &gt; -rw-r--r-- 1 root=
 root 0 Nov =C2=A08 19:48 max_ipc_namespaces<br>&gt;&gt; &gt; -rw-r--r-- 1 =
root root 0 Nov =C2=A08 19:48 max_mnt_namespaces<br>&gt;&gt; &gt; -rw-r--r-=
- 1 root root 0 Nov =C2=A08 19:48 max_net_namespaces<br>&gt;&gt; &gt; -rw-r=
--r-- 1 root root 0 Nov =C2=A08 19:48 max_pid_namespaces<br>&gt;&gt; &gt; -=
rw-r--r-- 1 root root 0 Nov =C2=A08 19:48 max_user_namespaces<br>&gt;&gt; &=
gt; -rw-r--r-- 1 root root 0 Nov =C2=A08 19:48 max_uts_namespaces<br>&gt;&g=
t; &gt;<br>&gt;&gt; &gt; These files allow you to limit the number of names=
paces that can be created<br>&gt;&gt; &gt; *per namespace* type. So let&#39=
;s say your system runs a bunch of user namespaces<br>&gt;&gt; &gt; you can=
 do:<br>&gt;&gt; &gt;<br>&gt;&gt; &gt; chb@conventiont|~<br>&gt;&gt; &gt;&g=
t; echo 0 &gt; /proc/sys/user/max_user_namesp<wbr>aces<br>&gt;&gt; &gt;<br>=
&gt;&gt; &gt; So that the next time you try to create a user namespaces you=
&#39;d see:<br>&gt;&gt; &gt;<br>&gt;&gt; &gt; chb@conventiont|~<br>&gt;&gt;=
 &gt;&gt; unshare -U<br>&gt;&gt; &gt; unshare: unshare failed: No space lef=
t on device<br>&gt;&gt; &gt;<br>&gt;&gt; &gt; So there&#39;s not even a nee=
d to upstream a new sysctl since we have ways of<br>&gt;&gt; &gt; blocking =
this.<br>&gt;&gt; &gt;<br>&gt;&gt; I&#39;m not sure how it&#39;s solving th=
e problem that my patch-set is addressing?<br>&gt;&gt; I agree though that =
the need for unprivileged_userns_clone sysctl goes<br>&gt;&gt; away as this=
 is equivalent to setting that sysctl to 0 as you have<br>&gt;&gt; describe=
d above.<br>&gt;<br>&gt; oh right that was the reasoning iirc for not needi=
ng the other sysctl.<br>&gt;<br>&gt;&gt; However as I mentioned earlier, bl=
ocking processes from creating<br>&gt;&gt; user-namespaces is not the solut=
ion. Processes should be able to<br>&gt;&gt; create namespaces as they are =
designed but at the same time we need to<br>&gt;&gt; have controls to &#39;=
contain&#39; them if a need arise. Setting max_no to 0<br>&gt;&gt; is not t=
he solution that I&#39;m looking for since it doesn&#39;t solve the<br>&gt;=
&gt; problem.<br>&gt;<br>&gt; well yesterday we were told that was explicit=
ly not the goal, but that was<br>&gt; not by you ... i just mention it to e=
xplain why we seem to be walking in<br>&gt; circles a bit.<br>&gt;<br>&gt; =
anyway the bounding set doesn&#39;t actually make sense so forget that. =C2=
=A0 the<br>&gt; question then is just whether it makes sense to allow thing=
s to continue<br>&gt; at all in this situation. =C2=A0would you mind indulg=
ing me by giving one or two<br>&gt; concrete examples in the previous known=
 cves of what capabilities you would<br>&gt; have dropped tto allow the res=
t to continue to be safely used?<br>&gt;<br>Of course. Let&#39;s take an ex=
ample of the CVE that I have mentioned in my cover-letter - <a href=3D"http=
s://cve.mitre.org/cgi-bin/cvename.cgi?name=3DCVE-2017-7308" target=3D"_blan=
k">CVE-2017-7308</a>. It&#39;s well documented and even has a exploit <a hr=
ef=3D"https://github.com/xairy/kernel-exploits/tree/master/CVE-2017-7308">c=
-program</a> that can demonstrate how it can be used against non-patched ke=
rnel. There is very nice <a href=3D"https://googleprojectzero.blogspot.kr/2=
017/05/exploiting-linux-kernel-via-packet.html" target=3D"_blank">blog post=
</a> about this vulnerability by Andrey Konovalov.<div><br></div><div>This =
is about the AF_PACKET socket interface that is protected behind NET_RAW ca=
pability. This capability is not available to unprivileged user. However, a=
ny unprivileged user can get NET_RAW capability (as demonstrated in the cov=
er-letter code that I have attached in this patch series) so this NET_RAW c=
apability is available to any unprivileged user on the host if the kernel h=
as user-namespaces available.=C2=A0=C2=A0<br><div><br></div><div>With this =
patch-set applied, all that is needed is to flip a bit with the sysctl (<sp=
an style=3D"font-size:12.8px">kernel.controlled_userns_<wbr>caps_</span><sp=
an style=3D"font-size:12.8px">whitelist) as demonstrated below -</span></di=
v><div><br></div><div><div>root@lphh6:~# uname -a</div><div>Linux lphh6 4.1=
4.0-smp-DEV #97 SMP @1510203579 x86_64 GNU/Linux</div><div>root@lphh6:~# sy=
sctl -q kernel.controlled_userns_caps_<wbr>whitelist</div><div>kernel.contr=
olled_userns_caps_<wbr>whitelist =3D 1f,ffffffff</div></div><div><br></div>=
<div>Now when I run the program (demo from the cover-letter) as a normal un=
privileged user I can&#39;t create a RAW socket in init-ns but I can in the=
 child-ns.</div><div><br></div><div>dumbo@lphh6:~$ /tmp/acquire_raw</div><d=
iv>Attempting to open RAW socket before unshare()...</div><div>socket() SOC=
K_RAW failed: : Operation not permitted</div><div>Attempting to open RAW so=
cket after unshare()...</div><div>Successfully opened RAW-Sock after unshar=
e().</div><div>dumbo@lphh6:~$</div><div><br></div><div>Now as a root user. =
Take off CAP_NET_RAW</div><div><br></div><div><div>root@lphh6:~# sysctl -w =
kernel.controlled_userns_caps_whitelist=3D1f,ffffdfff</div><div>kernel.cont=
rolled_userns_caps_whitelist =3D 1f,ffffdfff</div></div><div>root@lphh6:~#=
=C2=A0</div><div><br></div><div>Now run the same program as an unprivileged=
 user -</div><div><br></div><div><div>dumbo@lphh6:~$ /tmp/acquire_raw</div>=
<div>Attempting to open RAW socket before unshare()...</div><div>socket() S=
OCK_RAW failed: : Operation not permitted</div><div>Attempting to open RAW =
socket after unshare()...</div><div>socket() SOCK_RAW failed: : Operation n=
ot permitted</div><div>dumbo@lphh6:~$</div></div><div><br></div><div>Notice=
 that it has failed to create a raw socket in init and in child namespace. =
It&#39;s not blocking creation of user-namespaces but allowing admin turn i=
ndividual capability bits on and off.=C2=A0</div><div><br></div><div>This i=
s very simplistic example of just demonstrating how capability bits turn-on=
/off works. So let&#39;s assume a sandboxed environment where we don&#39;t =
know what a binary that we are about run in an environment which is identif=
ied as susceptible. By turning off the NET_RAW bit, the admin gets an assur=
ance that system is safe and if binary fails because it&#39;s not getting t=
his capability then that bad but a sad consequence (without compromising th=
e host integrity) but if it doesn&#39;t use the NET_RAW capability but any =
other combination of remaining 36 capabilities, it would get whatever is ne=
cessary. This means we can safely allow processes to create user-namespaces=
 by taking off certain capabilities in question for temporary/extended peri=
od until proper fix is applied without compromising the system integrity. T=
he impact will vary based on which capability is taken off and admin would =
/ should be ware of for the environment that he/she is dealing with.</div><=
div><br></div><div>thanks,</div><div>--mahesh..</div><div><br></div><div>&g=
t; thanks,<br></div><div>&gt; serge<br></div></div></div>

--f403045f6eb65f5017055d878a83--

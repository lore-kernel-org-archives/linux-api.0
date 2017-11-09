From: "Serge E. Hallyn" <serge@hallyn.com>
Subject: Re: Re: [PATCH resend 2/2] userns: control
 capabilities of some user namespaces
Date: Thu, 9 Nov 2017 10:14:22 -0600
Message-ID: <20171109161422.GA25835@mail.hallyn.com>
References: <20171106221418.GA32543@mail.hallyn.com>
 <CAFUG7CcEy9a=RxBQZJR-C_2VuhZXrzJ_QxJnrSxdM=ox36DsXQ@mail.gmail.com>
 <20171106233913.GA1518@mail.hallyn.com>
 <CAFUG7CcW077LHcQEqk7qy7iVvmi-3J8psD1Kwj45XvHThiZC6w@mail.gmail.com>
 <20171107032802.GA6669@mail.hallyn.com>
 <CAF2d9jiwu3Ss7Dtem8qSptKgMc0Mc_o8MAAJkWM5CwJaFsbrcg@mail.gmail.com>
 <20171108190223.vdkyepcaegmub6le@gmail.com>
 <CAF2d9jjed4Q7QvCD9Kpaa7L-Ngg3XFbJvt0jNVUUwt=52wDjjw@mail.gmail.com>
 <20171109032134.GA15666@mail.hallyn.com>
 <CAF2d9jgs5MYn1dMT2mbhF=6UB2Hoo5kwmJhXuE6memBfWzkWXQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <kernel-hardening-return-10479-glkh-kernel-hardening=m.gmane.org@lists.openwall.com>
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
Content-Disposition: inline
In-Reply-To: <CAF2d9jgs5MYn1dMT2mbhF=6UB2Hoo5kwmJhXuE6memBfWzkWXQ@mail.gmail.com>
To: Mahesh Bandewar =?utf-8?B?KOCkruCkueClh+CktiDgpKzgpILgpKHgpYfgpLXgpL4=?= =?utf-8?B?4KSwKQ==?= <maheshb@google.com>
Cc: "Serge E. Hallyn" <serge@hallyn.com>, Christian Brauner <christian.brauner@canonical.com>, Boris Lukashev <blukashev@sempervictus.com>, Daniel Micay <danielmicay@gmail.com>, Mahesh Bandewar <mahesh@bandewar.net>, LKML <linux-kernel@vger.kernel.org>, Netdev <netdev@vger.kernel.org>, Kernel-hardening <kernel-hardening@lists.openwall.com>, Linux API <linux-api@vger.kernel.org>, Kees Cook <keescook@chromium.org>, "Eric W . Biederman" <ebiederm@xmission.com>, Eric Dumazet <edumazet@google.com>, David Miller <davem@davemloft.net>
List-Id: linux-api@vger.kernel.org

Quoting Mahesh Bandewar (महेश बंडेवार) (maheshb@google.com):
> Of course. Let's take an example of the CVE that I have mentioned in
> my cover-letter -
> CVE-2017-7308(https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2017-7308).
> It's well documented and even has a
> exploit(https://github.com/xairy/kernel-exploits/tree/master/CVE-2017-7308)
> c-program that can demonstrate how it can be used against non-patched
> kernel. There is very nice blog
> post(https://googleprojectzero.blogspot.kr/2017/05/exploiting-linux-kernel-via-packet.html)
> about this vulnerability by Andrey Konovalov.

Ok, thanks.  It's a good example because the fix for this CVE actually
came by itself (http://kernel.ubuntu.com/git/ubuntu/ubuntu-xenial.git/tree/debian.master/changelog).
Normally multiple CVEs come at the same time, which would make a
workaround for one now helpful.  This is a good counter-example.

I'm going to maintain that I really don't like this.  But it looks
useful, so ack on the concept, I'll just have to look again at the
code now.  Thanks for indulging me.

-serge

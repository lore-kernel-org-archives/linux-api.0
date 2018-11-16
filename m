From: Paul Eggert <eggert@cs.ucla.edu>
Subject: Re: extending wait4(2) or waitid(2) linux syscall
Date: Fri, 16 Nov 2018 08:03:45 -0800
Message-ID: <5a64c828-b62a-acb4-ca0f-7b343cda3e1a@cs.ucla.edu>
References: <20170420152051.568f2050.albert.aribaud@3adev.fr>
 <20181115140441.GA2171@altlinux.org>
 <CAK8P3a0Gsqa8WTbALOUchRyEA7E2f3P1f=XQ8nD2xQaemfPpcQ@mail.gmail.com>
 <20181115153008.GC2171@altlinux.org>
 <68E78315-66C9-4CEE-B6A0-61485AFB314A@zytor.com>
 <CAK8P3a2bGYt1Z50eQsBv2pu_zd649SB1MjX-iWcZ-YnJ+Bhj1Q@mail.gmail.com>
 <87sh01uxlh.fsf@oldenburg.str.redhat.com>
 <CAK8P3a2kDbzzdHdPNaU9LBdLbdFejLYzx+Ntt4s5F=7u+scHsg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <libc-alpha-return-97317-glibc-alpha=m.gmane.org@sourceware.org>
List-Unsubscribe: <mailto:libc-alpha-unsubscribe-glibc-alpha=m.gmane.org@sourceware.org>
List-Subscribe: <mailto:libc-alpha-subscribe@sourceware.org>
List-Archive: <http://sourceware.org/ml/libc-alpha/>
List-Post: <mailto:libc-alpha@sourceware.org>
List-Help: <mailto:libc-alpha-help@sourceware.org>, <http://sourceware.org/ml/#faqs>
Sender: libc-alpha-owner@sourceware.org
In-Reply-To: <CAK8P3a2kDbzzdHdPNaU9LBdLbdFejLYzx+Ntt4s5F=7u+scHsg@mail.gmail.com>
To: Arnd Bergmann <arnd@arndb.de>, Florian Weimer <fweimer@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, "Dmitry V. Levin" <ldv@altlinux.org>, Albert ARIBAUD <albert.aribaud@3adev.fr>, GNU C Library <libc-alpha@sourceware.org>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On 11/16/18 7:17 AM, Arnd Bergmann wrote:
> we'd want something like
>
> int wait9(...)

We're getting uncomfortably close to the Perlis limit.

"If you have a procedure with 10 parameters, you probably missed some."

Perlis AJ. Epigrams on programming. SIGPLAN Notices. 1982:17(9):7-13. 
https://dx.doi.org/10.1145/947955.1083808 
http://pu.inf.uni-tuebingen.de/users/klaeren/epigrams.html

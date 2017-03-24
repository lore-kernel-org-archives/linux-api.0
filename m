From: Scot Doyle <lkml14@scotdoyle.com>
Subject: Re: [PATCH linux-next V2] tty: Disable default console blanking
 interval
Date: Thu, 23 Mar 2017 21:27:17 -0500 (CDT)
Message-ID: <alpine.DEB.2.20.1703232052010.2872@pc>
References: <1490190632-10464-1-git-send-email-tim.gardner@canonical.com> <1490195240-16372-1-git-send-email-tim.gardner@canonical.com> <alpine.DEB.2.20.1703222010220.2307@pc> <d7ca4c04-eb47-e0b5-7ee7-e69d96857f4d@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <d7ca4c04-eb47-e0b5-7ee7-e69d96857f4d@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Tim Gardner <tim.gardner@canonical.com>, "Austin S. Hemmelgarn" <ahferroin7@gmail.com>, Adam Borowski <kilobyte@angband.pl>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Jiri Slaby <jslaby@suse.com>, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Thu, 23 Mar 2017, Austin S. Hemmelgarn wrote:

> On 2017-03-22 21:32, Scot Doyle wrote:

> > On Wed, 22 Mar 2017, Tim Gardner wrote:
> > > BugLink: http://bugs.launchpad.net/bugs/869017
> > > 
> > > Console blanking is not enabling DPMS power saving (thereby negating any
> > > power-saving benefit), and is simply turning the screen content blank.
> > > This
> > > means that any crash output is invisible which is unhelpful on a server
> > > (virtual or otherwise).
> > > 
> > > Furthermore, CRT burn in concerns should no longer govern the default
> > > case.
> > > Affected users could always set consoleblank on the kernel command line.
> > 
> > Does screen blanking save some power by disabling the cursor blink?
> > 
> Unless you're dealing with ancient hardware, the difference in power usage is
> probably on the order of single digit micro-watts, which is not worth worrying
> about on almost anything you would expect to have a console display connected
> to.
> 

Here's a little more information.

powertop estimates fb_flashcursor consumes 24 to 28 milliwatts on a 
Haswell laptop with drm framebuffer console.

Since some commercial virtual machine providers include an emulated vga 
card, this table shows power usage estimates of a KVM-accelerated QEMU 
2.8.0 vm using QEMU's default vga card. The host and guest are Debian 
Stretch with kernel 4.9.6.

        QEMU    QEMU
        w/ SDL  with no
Minute  display display
------  ------- -------
0       1500mW  1540mW
        1310    76.1
        292     0.403
1       266     57.1
        320     58.4
        307     56.6
2       318     55.9
        268     57
        329     56.1
3       263     54.7
        264     55.7
        265     55.5
4       313     56.1
        341     55.2
        311     55.6
5       317     55.8
        340     57
        342     55.6
6       342     55.3
        278     54.9
        260     55.8
7       261     55.3
        260     55.2
        261     55
8       307     55.8
        262     55.3
        259     55.9
9       260     56.7
        337     55.8
        270     56.2
10      224     27.2
        222     27.2
        220     27.5
11      221     27.8
        220     27.3
        220     27.6
12      220     27.6
        219     27
        218     26.9
13      218     27.7
        217     26.9
        220     27.7
14      220     27.5
        221     27.4
        220     27.7
15      221     27.1
        221     27.8
        220     28.3
16      221     26.7
        220     27.5
        220     27.2
17      221     26.8
        221     27.1
        219     27.6
18      219     27.1
        218     26.8
        218     27.4
19      220     27.4
        218     27.4
        218     27.6
20      220     26.6

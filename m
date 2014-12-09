From: Davidlohr Bueso <dave@stgolabs.net>
Subject: Re: selftests: question about git repos containing selftest.
Date: Tue, 09 Dec 2014 12:53:55 -0800
Message-ID: <1418158435.10123.10.camel@stgolabs.net>
References: <7F8EB1E5A1A71643ACAD0928E03FFDE90E3D796BF2@USMBX1.msg.corp.akamai.com>
	 <20141209194602.GB20166@kroah.com>
	 <CAKocOOMGoCtDjG24cJhkrJ=EyhbW-qy6=v5pJaRBeSPZuvZWfA@mail.gmail.com>
	 <7F8EB1E5A1A71643ACAD0928E03FFDE90E3D796C21@USMBX1.msg.corp.akamai.com>
	 <CAKocOOMiaUDaP=PJ7R9dtsg001eP68hNLyryVQV=yLMC92aeyg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAKocOOMiaUDaP=PJ7R9dtsg001eP68hNLyryVQV=yLMC92aeyg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Shuah Khan <shuahkhan@gmail.com>
Cc: "Young, David" <dayoung@akamai.com>, Greg KH <gregkh@linuxfoundation.org>, "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>, "shuahkh@osg.samsung.com" <shuahkh@osg.samsung.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Tue, 2014-12-09 at 13:34 -0700, Shuah Khan wrote:
> On Tue, Dec 9, 2014 at 1:25 PM, Young, David <dayoung@akamai.com> wrote:
> > Thanks, I was definitely looking at the master branch of linux-kselftest.
> >
> > There are still more changes in linux-next repo, should those be considered as "in progress"?
> >
> 
> Patches in linux-kselftest fixes branch are the ones I included in my
> pull request
> I just sent out. linux-next might have some selftest patches that are part of a
> series that depend on a sub-system API. Maybe that is what you are seeing
> in linux-next.

Is there any reason why Andrew isn't handling kselftests? Considering it
spans multiple subsystems, it seems far more appropriate that way.

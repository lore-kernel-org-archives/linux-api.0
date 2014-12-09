From: Shuah Khan <shuahkhan@gmail.com>
Subject: Re: selftests: question about git repos containing selftest.
Date: Tue, 9 Dec 2014 14:27:18 -0700
Message-ID: <CAKocOOMNS3tZq3nFg7rTFnPRZwV0U-y4=34Yph+qTYN0kqTuQA@mail.gmail.com>
References: <7F8EB1E5A1A71643ACAD0928E03FFDE90E3D796BF2@USMBX1.msg.corp.akamai.com>
	<20141209194602.GB20166@kroah.com>
	<CAKocOOMGoCtDjG24cJhkrJ=EyhbW-qy6=v5pJaRBeSPZuvZWfA@mail.gmail.com>
	<7F8EB1E5A1A71643ACAD0928E03FFDE90E3D796C21@USMBX1.msg.corp.akamai.com>
	<CAKocOOMiaUDaP=PJ7R9dtsg001eP68hNLyryVQV=yLMC92aeyg@mail.gmail.com>
	<7F8EB1E5A1A71643ACAD0928E03FFDE90E3D796C56@USMBX1.msg.corp.akamai.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <7F8EB1E5A1A71643ACAD0928E03FFDE90E3D796C56@USMBX1.msg.corp.akamai.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Young, David" <dayoung@akamai.com>
Cc: Greg KH <gregkh@linuxfoundation.org>, "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>, "shuahkh@osg.samsung.com" <shuahkh@osg.samsung.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Tue, Dec 9, 2014 at 2:08 PM, Young, David <dayoung@akamai.com> wrote:
>
>> Do you have specific patches in linux-next that you have questions about?
>
> Mostly I am interested in executing kselftests via something like autotest or Hudson/jenkins as a quick smoketest.  I understand it's still very much an in-progress feature, but would like the closest thing to a stable set of tests to regularly clone and use.  I suppose I could just wait for whatever makes it into mainline, but I'm interested in seeing the planned test coverage and test output so that I can write appropriate "glue" for use with a continuous-integration test system.
>

David,

Please follow fixes branch for patches that are going to be in the next mainline
release. I am planning to create devel or experimental branch to make my next
revision install target patches available for early testing for people
that want to
play with work in progress. Hope this is helpful.

thanks,
-- Shuah

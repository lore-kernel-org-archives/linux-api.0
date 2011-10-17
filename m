From: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH, v10 3/3] cgroups: introduce timer slack controller
Date: Mon, 17 Oct 2011 18:36:44 +0200
Message-ID: <1318869404.4172.67.camel@twins>
References: <20111017124647.GA12838@srcf.ucam.org>
	 <1318856786.4172.22.camel@twins> <20111017141147.GA14581@srcf.ucam.org>
	 <1318861707.4172.32.camel@twins> <20111017144013.GA15447@srcf.ucam.org>
	 <1318862969.4172.45.camel@twins> <20111017145952.GB15769@srcf.ucam.org>
	 <1318864260.4172.54.camel@twins> <20111017151920.GA16664@srcf.ucam.org>
	 <1318864870.4172.61.camel@twins> <20111017153142.GA17047@srcf.ucam.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20111017153142.GA17047-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matthew Garrett <mjg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Arjan van de Ven <arjan-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Lennart Poettering <mzxreary-uLTowLwuiw4b1SvskN2V4Q@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>, Paul Menage <menage-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Li Zefan <lizf-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, jacob.jun.pan-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matt Helsley <matthltc-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Kay Sievers <kay.sievers-tD+1rO4QERM@public.gmane.org>, harald-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, david-o55+BOBDEFg@public.gmane.org, greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Mon, 2011-10-17 at 16:31 +0100, Matthew Garrett wrote:
> On Mon, Oct 17, 2011 at 05:21:10PM +0200, Peter Zijlstra wrote:
> 
> > Well what other cases are there? Can we enumerate them and come up 
> > with similar solutions?
> 
> Javascript has timers. We execute rather a lot of javascript from 
> sources we can't influence at all.

Which brings me to yet another gripe I've got with firefox, _WHY_ does
it run javascript for tabs I can't see? Simply freeze the interpreter.

Then again, what does JavaScript do with these timers? I don't really
see how javascript/random-native-binary are really different, something
needs doing. What something?

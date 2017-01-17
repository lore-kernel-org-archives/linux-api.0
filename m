From: Cyril Hrubis <chrubis@suse.cz>
Subject: Re: utimensat EACCES vs. EPERM in 4.8+
Date: Tue, 17 Jan 2017 08:57:03 +0100
Message-ID: <20170117075702.GB10417@rei.lan>
References: <18a5b416-ad6a-e679-d993-af7ffa0dcc10@redhat.com>
 <CAOssrKfb1-C8c=9bAPiairh+Lyf=w28r+RjSXTLQcQZ-=eWMRA@mail.gmail.com>
 <CAKgNAkjTkBMY0wrj3wsH39YF=bHp=8mbYrXkSPzn0X4ezfso1w@mail.gmail.com>
 <280513509.810300.1484639500985.JavaMail.zimbra@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <280513509.810300.1484639500985.JavaMail.zimbra@redhat.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Jan Stancek <jstancek@redhat.com>
Cc: mtk manpages <mtk.manpages@gmail.com>, Miklos Szeredi <mszeredi@redhat.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, viro <viro@zeniv.linux.org.uk>, guaneryu@gmail.com, ltp@lists.linux.it, Linux API <linux-api@vger.kernel.org>, Dave Chinner <dchinner@redhat.com>
List-Id: linux-api@vger.kernel.org

Hi!
> > Jan, thanks for spotting this.
> 
> Credit goes to Cyril. As for LTP-20170116 (released yesterday) we went
> with current documented behavior - few failures are expected on 4.8+.

Actually credit goes to SUSE QAM that caught the change on kernel
update :-).

-- 
Cyril Hrubis
chrubis@suse.cz

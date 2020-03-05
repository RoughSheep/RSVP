 function start_plot_eeg(num_name,h1,eeg_eachpeople,eeg_allpeople)

axes(h1);

if num_name<6
    plot(eeg_eachpeople(:,num_name));
elseif num_name==6
    plot(eeg_allpeople);
end


    